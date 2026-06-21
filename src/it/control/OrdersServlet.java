package it.control;

import java.io.IOException;
import java.util.List;

import javax.sql.DataSource;

import it.dao.OrderDao;
import it.dao.OrderDaoImpl;
import it.model.Order;
import it.model.OrderItem;
import it.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/OrdersServlet")
public class OrdersServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private OrderDao orderDao;

    @Override
    public void init() throws ServletException 
    {
        DataSource ds = (DataSource) getServletContext().getAttribute("DataSource");
        orderDao = new OrderDaoImpl(ds);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
        if (!AuthUtil.isLogged(request)) {
            response.sendRedirect("LoginServlet");
            return;
        }

        User user = (User) request.getSession().getAttribute("user");
        List<Order> orders = orderDao.doRetrieveByUser(user.getId());
        String selectedId = request.getParameter("id");

        request.setAttribute("orders", orders);

        if (selectedId != null) {
            int orderId = Integer.parseInt(selectedId);
            Order selectedOrder = orderDao.doRetrieveById(orderId);

            if (selectedOrder != null && selectedOrder.getUserId() == user.getId()) {
                List<OrderItem> items = orderDao.doRetrieveItemsByOrder(orderId);
                request.setAttribute("selectedOrder", selectedOrder);
                request.setAttribute("items", items);
            }
        }

        request.getRequestDispatcher("/WEB-INF/view/orders.jsp").forward(request, response);
    }
}
