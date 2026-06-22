<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="it.model.User" %>

<%
    User user =
        (User) session.getAttribute("user");
    String error =
        (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Shoe Store</title>
    <link rel="stylesheet" href="styles/style.css">
    <script src="scripts/validation.js" defer></script>
</head>

<body class="login-page">

<h1>Login</h1>

<nav>
    <a href="HomeServlet">Home</a>
    <a href="CartServlet">Carrello</a>
    <a href="RegisterServlet">Registrati</a>
</nav>

<% if(user != null) { %>

    <p>Sei gia loggato come <%= user.getNome() %>.</p>
    <a href="LogoutServlet">Logout</a>

<% } else { %>

    <% if(error != null) { %>
        <p><%= error %></p>
    <% } %>

    <form action="LoginServlet" method="post" data-validate="login">
        <label>Email</label>
        <input type="email" name="email" data-rule="email" required>
        <span class="field-error" data-error-for="email"></span>

        <label>Password</label>
        <input type="password" name="password" data-rule="password" required>
        <span class="field-error" data-error-for="password"></span>

        <button class="action-button action-primary" type="submit">
            <span>Accedi</span>
            <span class="action-button-icon" aria-hidden="true">&rarr;</span>
        </button>
    </form>

    <p>Non hai un account? <a href="RegisterServlet">Crea il tuo account</a></p>

<% } %>

<%@ include file="common/footer.jsp" %>

</body>
</html>
