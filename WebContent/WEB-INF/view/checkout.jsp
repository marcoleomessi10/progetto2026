<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="it.model.CartItem" %>

<%
    List<CartItem> cart =
        (List<CartItem>) session.getAttribute("cart");
    String token =
        (String) session.getAttribute("authToken");
    String error =
        (String) request.getAttribute("error");
    double total = 0;
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - Shoe Store</title>
    <link rel="stylesheet" href="styles/style.css">
    <script src="scripts/validation.js" defer></script>
</head>
<body class="checkout-page">

<h1>Checkout</h1>

<nav>
    <a href="HomeServlet">Home</a>
    <a href="CartServlet">Carrello</a>
    <a href="OrdersServlet">I miei ordini</a>
    <a href="LogoutServlet">Logout</a>
</nav>

<% if(error != null) { %>
    <p class="error"><%= error %></p>
<% } %>

<% if(cart != null) { %>
    <% for(CartItem item : cart) { total += item.getSubtotal(); } %>
<% } %>

<h2>Totale: &euro; <%= total %></h2>

<form action="CheckoutServlet" method="post" data-validate="checkout">
    <input type="hidden" name="token" value="<%= token %>">

    <label>Indirizzo spedizione</label>
    <input type="text" name="shippingAddress" data-rule="address" required>
    <span class="field-error" data-error-for="shippingAddress"></span>

    <label>Metodo pagamento</label>
    <select name="paymentMethod" data-rule="required" required>
        <option value="">Scegli metodo</option>
        <option value="Carta">Carta</option>
        <option value="PayPal">PayPal</option>
        <option value="Contrassegno">Contrassegno</option>
    </select>
    <span class="field-error" data-error-for="paymentMethod"></span>

    <button class="checkout-submit action-button action-primary" type="submit">
        <span>Conferma ordine</span>
        <span class="checkout-submit-icon action-button-icon" aria-hidden="true">&rarr;</span>
    </button>
</form>

<%@ include file="common/footer.jsp" %>

</body>
</html>
