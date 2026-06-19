package it.control;

import java.util.UUID;

import it.model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class AuthUtil {

    public static String createToken(HttpSession session) 
    {
        String token = UUID.randomUUID().toString();
        session.setAttribute("authToken", token);
        return token;
    }

    public static boolean isLogged(HttpServletRequest request) 
    {
        HttpSession session = request.getSession(false);
        return session != null
                && session.getAttribute("user") != null
                && session.getAttribute("authToken") != null;
    }

    public static boolean isAdmin(HttpServletRequest request) 
    {
        HttpSession session = request.getSession(false);

        if (session == null) {
            return false;
        }

        User user = (User) session.getAttribute("user");
        return user != null
                && session.getAttribute("authToken") != null
                && "ADMIN".equals(user.getRuolo());
    }

    public static boolean isValidToken(HttpServletRequest request) 
    {
        HttpSession session = request.getSession(false);

        if (session == null) {
            return false;
        }

        String sessionToken = (String) session.getAttribute("authToken");
        String requestToken = request.getParameter("token");
        return sessionToken != null && sessionToken.equals(requestToken);
    }
}
