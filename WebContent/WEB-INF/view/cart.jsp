<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="it.model.CartItem" %>
<%@ page import="it.model.User" %>

<%
    List<CartItem> cart =
        (List<CartItem>) session.getAttribute("cart");
    User user =
        (User) session.getAttribute("user");
    double total = 0;
    int cartCount = 0;

    if(cart != null) {
        for(CartItem item : cart) {
            total += item.getSubtotal();
            cartCount += item.getQuantity();
        }
    }
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Carrello - DAMA Shoes</title>
    <link rel="stylesheet" href="styles/style.css">
    <script src="scripts/validation.js" defer></script>
</head>

<body class="storefront cart-page">

<div class="top-strip">
    <span>Spedizione gratuita sopra &euro; 100</span>
    <div>
        <% if(user == null) { %>
            <a href="LoginServlet">Accedi</a>
            <a href="RegisterServlet">Registrati</a>
        <% } else { %>
            <span>Ciao, <%= user.getNome() %></span>
            <a href="LogoutServlet">Logout</a>
        <% } %>
    </div>
</div>

<header class="site-header">
    <a class="brand" href="HomeServlet">DAMA</a>
    <button class="nav-toggle" type="button" data-menu-toggle aria-expanded="false">Menu</button>

    <nav class="site-nav" data-menu>
        <a href="HomeServlet#catalogo">Novita</a>
        <a href="HomeServlet#catalogo">Sneakers</a>
        <a href="HomeServlet#catalogo">Running</a>
        <% if(user != null) { %>
            <a href="OrdersServlet">I miei ordini</a>
        <% } %>
    </nav>

    <div class="header-actions">
        <a class="icon-link active" href="CartServlet" aria-current="page">
            Carrello <span class="cart-count"><%= cartCount %></span>
        </a>
    </div>
</header>

<main class="cart-main">
    <div class="cart-heading">
        <div>
            <p class="eyebrow">Il tuo ordine</p>
            <h1>Carrello</h1>
        </div>
        <p><%= cartCount %> <%= cartCount == 1 ? "articolo" : "articoli" %></p>
    </div>

    <% if(cart == null || cart.isEmpty()) { %>

        <section class="cart-empty">
            <span class="cart-empty-number">00</span>
            <h2>Il carrello e vuoto</h2>
            <p>Scopri la collezione e scegli il prossimo paio da portare con te.</p>
            <a class="button cart-primary-action" href="HomeServlet#catalogo">Esplora le scarpe</a>
        </section>

    <% } else { %>

        <div class="cart-layout">
            <section class="cart-items" aria-label="Prodotti nel carrello">
                <% for(CartItem item : cart) { %>
                    <article class="cart-item">
                        <a class="cart-item-image" href="ProductServlet?id=<%= item.getProduct().getId() %>">
                            <img src="images/<%= item.getProduct().getImmagine() %>?v=15"
                                 alt="<%= item.getProduct().getNome() %>">
                        </a>

                        <div class="cart-item-info">
                            <div class="cart-item-title">
                                <div>
                                    <p class="cart-item-brand"><%= item.getProduct().getMarca() %></p>
                                    <h2>
                                        <a href="ProductServlet?id=<%= item.getProduct().getId() %>">
                                            <%= item.getProduct().getNome() %>
                                        </a>
                                    </h2>
                                </div>
                                <strong>&euro; <%= String.format("%.2f", item.getSubtotal()) %></strong>
                            </div>

                            <p class="cart-item-stock"><%= item.getProduct().getQuantitaDisponibile() %> disponibili</p>

                            <div class="cart-item-actions">
                                <form class="cart-quantity-form" action="CartServlet" method="post">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="id" value="<%= item.getProduct().getId() %>">
                                    <label for="quantity-<%= item.getProduct().getId() %>">Quantita</label>
                                    <input id="quantity-<%= item.getProduct().getId() %>"
                                           type="number"
                                           name="quantity"
                                           min="1"
                                           max="<%= item.getProduct().getQuantitaDisponibile() %>"
                                           value="<%= item.getQuantity() %>">
                                    <button class="cart-update" type="submit">Aggiorna</button>
                                </form>

                                <form action="CartServlet" method="post">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="id" value="<%= item.getProduct().getId() %>">
                                    <button class="cart-remove" type="submit" aria-label="Rimuovi <%= item.getProduct().getNome() %>">
                                        Rimuovi
                                    </button>
                                </form>
                            </div>
                        </div>
                    </article>
                <% } %>

                <form class="cart-clear-form" action="CartServlet" method="post">
                    <input type="hidden" name="action" value="clear">
                    <button class="cart-clear" type="submit">Svuota carrello</button>
                </form>
            </section>

            <aside class="cart-summary">
                <p class="eyebrow">Riepilogo</p>
                <h2>Totale ordine</h2>

                <dl class="cart-totals">
                    <div>
                        <dt>Subtotale</dt>
                        <dd>&euro; <%= String.format("%.2f", total) %></dd>
                    </div>
                    <div>
                        <dt>Spedizione</dt>
                        <dd><%= total >= 100 ? "Gratuita" : "Calcolata al checkout" %></dd>
                    </div>
                    <div class="cart-grand-total">
                        <dt>Totale</dt>
                        <dd>&euro; <%= String.format("%.2f", total) %></dd>
                    </div>
                </dl>

                <% if(user == null) { %>
                    <a class="button cart-primary-action" href="LoginServlet">Accedi per ordinare</a>
                    <p class="cart-login-note">
                        Non hai un account? <a href="RegisterServlet">Registrati</a>
                    </p>
                <% } else { %>
                    <a class="button cart-primary-action" href="CheckoutServlet">Procedi al checkout</a>
                <% } %>

                <a class="cart-continue" href="HomeServlet#catalogo">Continua lo shopping</a>
                <p class="cart-assurance">Pagamento protetto e dati dell'ordine salvati in modo sicuro.</p>
            </aside>
        </div>

    <% } %>
</main>

<%@ include file="common/footer.jsp" %>

</body>
</html>
