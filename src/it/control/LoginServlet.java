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

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

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
        request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userDao.doRetrieveByEmailPassword(email, password);

        if (user != null) {
            request.getSession().setAttribute("user", user);
            AuthUtil.createToken(request.getSession());
            response.sendRedirect("HomeServlet");
        } else {
            request.setAttribute("error", "Email o password non validi");
            request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
        }
    }
}
