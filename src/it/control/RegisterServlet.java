package it.control;

import java.io.IOException;

import javax.sql.DataSource;

import it.dao.UserDao;
import it.dao.UserDaoImpl;
import it.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UserDao userDao;

    @Override
    public void init() throws ServletException 
    {
        DataSource ds = (DataSource) getServletContext().getAttribute("DataSource");
        userDao = new UserDaoImpl(ds);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
        request.getRequestDispatcher("/WEB-INF/view/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confermaPassword = request.getParameter("confermaPassword");
        String telefono = request.getParameter("telefono");

        if (!password.equals(confermaPassword)) {
            request.setAttribute("error", "Le password non coincidono");
            request.getRequestDispatcher("/WEB-INF/view/register.jsp").forward(request, response);
            return;
        }

        if (userDao.doRetrieveByEmail(email) != null) {
            request.setAttribute("error", "Email gia registrata");
            request.getRequestDispatcher("/WEB-INF/view/register.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setNome(nome);
        user.setCognome(cognome);
        user.setEmail(email);
        user.setPasswordHash(password);
        user.setTelefono(telefono);

        userDao.doSave(user);

        User savedUser = userDao.doRetrieveByEmailPassword(email, password);
        request.getSession().setAttribute("user", savedUser);
        AuthUtil.createToken(request.getSession());
        response.sendRedirect("HomeServlet");
    }
}
