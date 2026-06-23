package it.control;

import java.io.IOException;
import java.util.List;

import javax.sql.DataSource;

import it.dao.ProductDao;
import it.dao.ProductDaoImpl;
import it.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/HomeServlet")
public class HomeServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
    private ProductDao productDao;

    public HomeServlet() {
        super();
    }

    @Override
    public void init() throws ServletException {
        DataSource ds = (DataSource) getServletContext().getAttribute("DataSource");
        productDao = new ProductDaoImpl(ds);
    }

    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String categoria = request.getParameter("categoria");
		List<Product> products;

		if (categoria != null && !categoria.trim().isEmpty()) {
			products = productDao.doRetrieveByCategoryName(categoria.trim());
		} else {
			products = productDao.doRetrieveAll();
		}

		request.setAttribute("products", products);
		request.setAttribute("categoriaAttiva", categoria);
		request.getRequestDispatcher("/WEB-INF/view/home.jsp").forward(request, response);
	}

    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
