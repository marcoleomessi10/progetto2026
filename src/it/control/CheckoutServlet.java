package it.control;

import java.io.IOException;
import java.util.List;

import javax.sql.DataSource;

import it.dao.OrderDao;
import it.dao.OrderDaoImpl;
import it.dao.ProductDao;
import it.dao.ProductDaoImpl;
import it.model.CartItem;
import it.model.Product;
import it.model.Order;
import it.model.OrderItem;
import it.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private OrderDao orderDao;
    private ProductDao productDao;

    @Override
    public void init() throws ServletException 
    {
        DataSource ds = (DataSource) getServletContext().getAttribute("DataSource");
        orderDao = new OrderDaoImpl(ds);
        productDao = new ProductDaoImpl(ds);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
        if (!AuthUtil.isLogged(request)) {
            response.sendRedirect("LoginServlet");
            return;
        }

        if (isCartEmpty(request.getSession())) {
            response.sendRedirect("CartServlet");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/view/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
        if (!AuthUtil.isLogged(request)) {
            response.sendRedirect("LoginServlet");
            return;
        }

        if (!AuthUtil.isValidToken(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        HttpSession session = request.getSession();

        if (isCartEmpty(session)) {
            response.sendRedirect("CartServlet");
            return;
        }

        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        User user = (User) session.getAttribute("user");
        double total = 0;

        for (CartItem item : cart) {
            Product product = productDao.doRetrieveById(item.getProduct().getId());

            if (product == null || !product.isAttivo() || product.getQuantitaDisponibile() < item.getQuantity()) {
                request.setAttribute("error", "Un prodotto nel carrello non e piu disponibile nella quantita richiesta");
                request.getRequestDispatcher("/WEB-INF/view/checkout.jsp").forward(request, response);
                return;
            }

            item.setProduct(product);
            total += item.getSubtotal();
        }

        Order order = new Order();
        order.setUserId(user.getId());
        order.setTotale(total);
        order.setIndirizzoSpedizione(request.getParameter("shippingAddress"));
        order.setMetodoPagamento(request.getParameter("paymentMethod"));
        order.setStato("PROCESSING");

        int orderId = orderDao.doSaveOrder(order);

        if (orderId < 1) {
            request.setAttribute("error", "Errore durante il salvataggio dell'ordine");
            request.getRequestDispatcher("/WEB-INF/view/checkout.jsp").forward(request, response);
            return;
        }

        for (CartItem cartItem : cart) {
            OrderItem item = new OrderItem();
            item.setOrderId(orderId);
            item.setProductId(cartItem.getProduct().getId());
            item.setNomeProdotto(cartItem.getProduct().getNome());
            item.setMarcaProdotto(cartItem.getProduct().getMarca());
            item.setTaglia(0);
            item.setPrezzoAcquisto(cartItem.getProduct().getPrezzo());
            item.setQuantita(cartItem.getQuantity());
            item.setSubtotale(cartItem.getSubtotal());
            orderDao.doSaveOrderItem(item);

            int newQuantity = cartItem.getProduct().getQuantitaDisponibile() - cartItem.getQuantity();
            productDao.updateQuantity(cartItem.getProduct().getId(), Math.max(newQuantity, 0));
        }

        cart.clear();
        response.sendRedirect("OrdersServlet?id=" + orderId);
    }

    @SuppressWarnings("unchecked")
    private boolean isCartEmpty(HttpSession session) 
    {
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        return cart == null || cart.isEmpty();
    }
}
