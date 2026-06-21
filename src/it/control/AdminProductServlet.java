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

@WebServlet("/AdminProductServlet")
public class AdminProductServlet extends HttpServlet {

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
        if (!AuthUtil.isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String editId = request.getParameter("edit");

        if (editId != null) {
            request.setAttribute("editProduct", productDao.doRetrieveById(Integer.parseInt(editId)));
        }

        request.setAttribute("products", productDao.doRetrieveAllForAdmin());
        request.getRequestDispatcher("/WEB-INF/view/admin/products.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
        if (!AuthUtil.isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (!AuthUtil.isValidToken(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            productDao.doDelete(Integer.parseInt(request.getParameter("id")));
            response.sendRedirect("AdminProductServlet");
            return;
        }

        Product product = new Product();
        product.setNome(request.getParameter("nome"));
        product.setDescrizione(request.getParameter("descrizione"));
        product.setMarca(request.getParameter("marca"));
        product.setPrezzo(Double.parseDouble(request.getParameter("prezzo")));
        product.setCategoria(request.getParameter("categoria"));
        product.setQuantitaDisponibile(Integer.parseInt(request.getParameter("quantita")));
        product.setImmagine(request.getParameter("immagine"));
        product.setAttivo("on".equals(request.getParameter("attivo")));

        if ("update".equals(action)) {
            product.setId(Integer.parseInt(request.getParameter("id")));
            productDao.doUpdate(product);
        } else {
            productDao.doSave(product);
        }

        response.sendRedirect("AdminProductServlet");
    }
}
