package it.control;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.sql.DataSource;

import it.dao.ProductDao;
import it.dao.ProductDaoImpl;
import it.model.CartItem;
import it.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private ProductDao productDao;

    @Override
    public void init() throws ServletException 
    {
        DataSource ds = (DataSource) getServletContext().getAttribute("DataSource");
        productDao = new ProductDaoImpl(ds);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
        request.getRequestDispatcher("/WEB-INF/view/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
        String action = request.getParameter("action");

        if (action == null) {
            action = "add";
        }

        HttpSession session = request.getSession();
        List<CartItem> cart = getCart(session);

        if ("add".equals(action)) {
            addProduct(request, cart);
        } else if ("update".equals(action)) {
            updateProduct(request, cart);
        } else if ("remove".equals(action)) {
            removeProduct(request, cart);
        } else if ("clear".equals(action)) {
            cart.clear();
        }

        response.sendRedirect("CartServlet");
    }

    @SuppressWarnings("unchecked")
    private List<CartItem> getCart(HttpSession session) 
    {
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }

        return cart;
    }

    private void addProduct(HttpServletRequest request, List<CartItem> cart) 
    {
        int id = Integer.parseInt(request.getParameter("id"));
        Product product = productDao.doRetrieveById(id);

        if (product == null || !product.isAttivo() || product.getQuantitaDisponibile() <= 0) {
            return;
        }

        for (CartItem item : cart) {
            if (item.getProduct().getId() == id) {
                int quantity = Math.min(item.getQuantity() + 1, product.getQuantitaDisponibile());
                item.setQuantity(quantity);
                return;
            }
        }

        cart.add(new CartItem(product, 1));
    }

    private void updateProduct(HttpServletRequest request, List<CartItem> cart) 
    {
        int id = Integer.parseInt(request.getParameter("id"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        if (quantity <= 0) {
            removeProduct(request, cart);
            return;
        }

        for (CartItem item : cart) {
            if (item.getProduct().getId() == id) {
                int safeQuantity = Math.min(quantity, item.getProduct().getQuantitaDisponibile());
                item.setQuantity(safeQuantity);
                return;
            }
        }
    }

    private void removeProduct(HttpServletRequest request, List<CartItem> cart) 
    {
        int id = Integer.parseInt(request.getParameter("id"));
        Iterator<CartItem> iterator = cart.iterator();

        while (iterator.hasNext()) {
            CartItem item = iterator.next();

            if (item.getProduct().getId() == id) {
                iterator.remove();
                return;
            }
        }
    }
}
