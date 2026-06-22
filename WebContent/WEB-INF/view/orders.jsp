<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="it.model.Order" %>
<%@ page import="it.model.OrderItem" %>

<%
    List<Order> orders =
        (List<Order>) request.getAttribute("orders");
    Order selectedOrder =
        (Order) request.getAttribute("selectedOrder");
    List<OrderItem> items =
        (List<OrderItem>) request.getAttribute("items");
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>I miei ordini — Shoe Store</title>
    <link rel="stylesheet" href="styles/style.css">
    <style>
        .status-badge {
            display: inline-flex; align-items: center; gap: .3rem;
            padding: .25rem .7rem; border-radius: 999px;
            font-size: .78rem; font-weight: 700;
        }
        .status-processing { background: #fffaeb; color: #b54708; }
        .status-shipped    { background: #eff8ff; color: #175cd3; }
        .status-delivered  { background: #ecfdf3; color: #027a48; }
        .detail-card {
            background: #fff; border: 1px solid var(--border);
            border-radius: 1rem; padding: 1.5rem; margin-top: 2rem;
            box-shadow: 0 2px 8px rgba(15,23,42,.04);
        }
        .order-meta { display: flex; gap: 2rem; flex-wrap: wrap; margin-bottom: 1.25rem; }
        .order-meta-item { display: flex; flex-direction: column; gap: .2rem; }
        .order-meta-item small { color: var(--muted); font-size: .78rem; font-weight: 700; text-transform: uppercase; }
    </style>
</head>
<body>

<h1>I miei ordini</h1>

<nav>
    <a href="HomeServlet">Home</a>
    <a href="CartServlet">Carrello</a>
    <a href="LogoutServlet">Logout</a>
</nav>

<div class="container">

<% if (orders == null || orders.isEmpty()) { %>
    <div class="card" style="text-align:center;padding:3rem;">
        <p style="font-size:1.1rem;color:var(--muted);">Non hai ancora effettuato ordini.</p>
        <a class="action-button action-primary action-compact" href="HomeServlet#catalogo"
           style="display:inline-flex;margin-top:1rem;">Esplora il catalogo</a>
    </div>
<% } else { %>
    <div class="table-wrap card" style="padding:0;border-radius:1rem;overflow:hidden;">
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Data</th>
                    <th>Totale</th>
                    <th>Stato</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <% for (Order order : orders) {
                    String sc = "status-processing", sl = "In elaborazione";
                    if ("SHIPPED".equals(order.getStato()))   { sc = "status-shipped";   sl = "Spedito"; }
                    if ("DELIVERED".equals(order.getStato())) { sc = "status-delivered"; sl = "Consegnato"; }
                %>
                <tr <%= selectedOrder != null && selectedOrder.getId() == order.getId() ? "style='background:#f0f5ff;'" : "" %>>
                    <td class="muted"><%= order.getId() %></td>
                    <td><%= order.getDataOrdine() %></td>
                    <td><strong>&euro;&nbsp;<%= order.getTotale() %></strong></td>
                    <td><span class="status-badge <%= sc %>"><%= sl %></span></td>
                    <td>
                        <a class="action-button action-secondary action-compact"
                           href="OrdersServlet?id=<%= order.getId() %>">Dettaglio</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
<% } %>

<% if (selectedOrder != null && items != null) {
    String sc = "status-processing", sl = "In elaborazione";
    if ("SHIPPED".equals(selectedOrder.getStato()))   { sc = "status-shipped";   sl = "Spedito"; }
    if ("DELIVERED".equals(selectedOrder.getStato())) { sc = "status-delivered"; sl = "Consegnato"; }
%>
<div class="detail-card">
    <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:1rem;
                margin-bottom:1.25rem;padding-bottom:1rem;border-bottom:1px solid var(--border);">
        <div>
            <p class="eyebrow" style="margin:0 0 .25rem;">Dettaglio ordine</p>
            <h2 style="margin:0;font-size:1.5rem;">#<%= selectedOrder.getId() %></h2>
        </div>
        <span class="status-badge <%= sc %>"><%= sl %></span>
    </div>

    <div class="order-meta">
        <div class="order-meta-item">
            <small>Data</small>
            <strong><%= selectedOrder.getDataOrdine() %></strong>
        </div>
        <div class="order-meta-item">
            <small>Indirizzo</small>
            <strong><%= selectedOrder.getIndirizzoSpedizione() %></strong>
        </div>
        <div class="order-meta-item">
            <small>Pagamento</small>
            <strong><%= selectedOrder.getMetodoPagamento() %></strong>
        </div>
        <div class="order-meta-item">
            <small>Totale</small>
            <strong style="font-size:1.2rem;">&euro;&nbsp;<%= selectedOrder.getTotale() %></strong>
        </div>
    </div>

    <div class="table-wrap" style="border:1px solid var(--border);border-radius:.75rem;overflow:hidden;">
        <table>
            <thead>
                <tr>
                    <th>Prodotto</th>
                    <th>Marca</th>
                    <th>Prezzo</th>
                    <th>Qtà</th>
                    <th>Subtotale</th>
                </tr>
            </thead>
            <tbody>
                <% for (OrderItem item : items) { %>
                <tr>
                    <td><strong><%= item.getNomeProdotto() %></strong></td>
                    <td><%= item.getMarcaProdotto() %></td>
                    <td>&euro;&nbsp;<%= item.getPrezzoAcquisto() %></td>
                    <td><%= item.getQuantita() %></td>
                    <td><strong>&euro;&nbsp;<%= item.getSubtotale() %></strong></td>
                </tr>
                <% } %>
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="4" style="text-align:right;font-weight:700;color:var(--muted);">Totale</td>
                    <td><strong>&euro;&nbsp;<%= selectedOrder.getTotale() %></strong></td>
                </tr>
            </tfoot>
        </table>
    </div>
</div>
<% } %>

</div>

<%@ include file="common/footer.jsp" %>

</body>
</html>
