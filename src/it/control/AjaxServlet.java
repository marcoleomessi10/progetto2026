package it.control;

import java.io.IOException;

import javax.sql.DataSource;

import it.dao.ProductDao;
import it.dao.ProductDaoImpl;
import it.dao.UserDao;
import it.dao.UserDaoImpl;
import it.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AjaxServlet")
public class AjaxServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UserDao userDao;
    private ProductDao productDao;

    @Override
    public void init() throws ServletException 
    {
        DataSource ds = (DataSource) getServletContext().getAttribute("DataSource");
        userDao = new UserDaoImpl(ds);
        productDao = new ProductDaoImpl(ds);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
        response.setContentType("application/json;charset=UTF-8");
        String type = request.getParameter("type");

        if ("email".equals(type)) {
            String email = request.getParameter("email");
            boolean exists = email != null && userDao.doRetrieveByEmail(email) != null;
            response.getWriter().write("{\"exists\":" + exists + "}");
            return;
        }

        if ("stock".equals(type)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Product product = productDao.doRetrieveById(id);
            int stock = product == null ? 0 : product.getQuantitaDisponibile();
            response.getWriter().write("{\"stock\":" + stock + "}");
            return;
        }

        response.getWriter().write("{}");
    }
}
