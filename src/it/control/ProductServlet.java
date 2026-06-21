package it.control;

import java.io.IOException;

import javax.sql.DataSource;

import it.dao.ProductDao;
import it.dao.ProductDaoImpl;
import it.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {

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
        int id = Integer.parseInt(request.getParameter("id"));
        Product product = productDao.doRetrieveById(id);

        if (product == null || !product.isAttivo()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        request.setAttribute("product", product);
        request.getRequestDispatcher("/WEB-INF/view/product-detail.jsp").forward(request, response);
    }
}
