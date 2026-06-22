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
    <title>Registrazione - Shoe Store</title>
    <link rel="stylesheet" href="styles/style.css">
    <script src="scripts/validation.js" defer></script>
</head>

<body class="register-page">

<h1>Crea account</h1>

<nav>
    <a href="HomeServlet">Home</a>
    <a href="CartServlet">Carrello</a>
    <a href="LoginServlet">Login</a>
</nav>

<% if(user != null) { %>

    <p>Sei gia loggato come <%= user.getNome() %>.</p>
    <a href="LogoutServlet">Logout</a>

<% } else { %>

    <% if(error != null) { %>
        <p><%= error %></p>
    <% } %>

    <form action="RegisterServlet" method="post" data-validate="register">
        <label>Nome</label>
        <input type="text" name="nome" data-rule="name" required>
        <span class="field-error" data-error-for="nome"></span>

        <label>Cognome</label>
        <input type="text" name="cognome" data-rule="name" required>
        <span class="field-error" data-error-for="cognome"></span>

        <label>Email</label>
        <input type="email" name="email" data-rule="email" data-ajax-email="true" required>
        <span class="field-error" data-error-for="email"></span>

        <label>Telefono</label>
        <input type="text" name="telefono" data-rule="phone">
        <span class="field-error" data-error-for="telefono"></span>

        <label>Password</label>
        <input type="password" name="password" data-rule="password" required>
        <span class="field-error" data-error-for="password"></span>

        <label>Conferma password</label>
        <input type="password" name="confermaPassword" data-rule="confirmPassword" required>
        <span class="field-error" data-error-for="confermaPassword"></span>

        <button class="register-submit action-button action-primary" type="submit">
            <span>Crea il mio account</span>
            <span class="register-submit-icon action-button-icon" aria-hidden="true">&rarr;</span>
        </button>
    </form>

    <p>Hai gia un account? <a href="LoginServlet">Accedi</a></p>

<% } %>

<%@ include file="common/footer.jsp" %>

</body>
</html>
