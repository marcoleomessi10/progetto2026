package it.control;

import java.io.IOException;
import java.util.List;

import javax.sql.DataSource;

import it.dao.OrderDao;
import it.dao.OrderDaoImpl;
import it.model.Order;
import it.model.OrderItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AdminOrdersServlet")
public class AdminOrdersServlet extends HttpServlet {

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
        if (!AuthUtil.isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String userId = request.getParameter("userId");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        List<Order> orders;

        if (hasText(userId) && hasText(startDate) && hasText(endDate)) {
            orders = orderDao.doRetrieveByUserAndDateRange(Integer.parseInt(userId), startDate, endDate + " 23:59:59");
        } else if (hasText(userId)) {
            orders = orderDao.doRetrieveByUser(Integer.parseInt(userId));
        } else if (hasText(startDate) && hasText(endDate)) {
            orders = orderDao.doRetrieveByDateRange(startDate, endDate + " 23:59:59");
        } else {
            orders = orderDao.doRetrieveAll();
        }

        String selectedId = request.getParameter("id");

        if (selectedId != null) {
            int orderId = Integer.parseInt(selectedId);
            List<OrderItem> items = orderDao.doRetrieveItemsByOrder(orderId);
            request.setAttribute("selectedOrder", orderDao.doRetrieveById(orderId));
            request.setAttribute("items", items);
        }

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/WEB-INF/view/admin/orders.jsp").forward(request, response);
    }

    private boolean hasText(String value) 
    {
        return value != null && !value.isBlank();
    }
}
