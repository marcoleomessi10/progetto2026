package it.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import it.model.Order;
import it.model.OrderItem;

public class OrderDaoImpl implements OrderDao {

    private DataSource ds;

    public OrderDaoImpl(DataSource ds) 
    {
        this.ds = ds;
    }

    @Override
    public int doSaveOrder(Order o) 
    {
        String sql = "INSERT INTO orders "
                + "(user_id, order_date, total, shipping_address, payment_method, status) "
                + "VALUES (?, NOW(), ?, ?, ?, ?)";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, o.getUserId());
            ps.setDouble(2, o.getTotale());
            ps.setString(3, o.getIndirizzoSpedizione());
            ps.setString(4, o.getMetodoPagamento());
            ps.setString(5, o.getStato());

            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return -1;
    }

    @Override
    public void doSaveOrderItem(OrderItem i) 
    {
        String sql = "INSERT INTO order_items "
                + "(order_id, product_id, product_name, product_brand, size, purchase_price, quantity, subtotal) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, i.getOrderId());
            ps.setInt(2, i.getProductId());
            ps.setString(3, i.getNomeProdotto());
            ps.setString(4, i.getMarcaProdotto());
            ps.setInt(5, i.getTaglia());
            ps.setDouble(6, i.getPrezzoAcquisto());
            ps.setInt(7, i.getQuantita());
            ps.setDouble(8, i.getSubtotale());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Order doRetrieveById(int id) 
    {
        String sql = "SELECT * FROM orders WHERE id = ?";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapOrder(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public List<OrderItem> doRetrieveItemsByOrder(int orderId) 
    {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE order_id = ?";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OrderItem item = new OrderItem();

                item.setId(rs.getInt("id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setNomeProdotto(rs.getString("product_name"));
                item.setMarcaProdotto(rs.getString("product_brand"));
                item.setTaglia(rs.getInt("size"));
                item.setPrezzoAcquisto(rs.getDouble("purchase_price"));
                item.setQuantita(rs.getInt("quantity"));
                item.setSubtotale(rs.getDouble("subtotal"));

                list.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<Order> doRetrieveByUser(int userId) 
    {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<Order> doRetrieveByUserAndDateRange(int userId, String startDate, String endDate) 
    {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? AND order_date BETWEEN ? AND ? ORDER BY order_date DESC";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, startDate);
            ps.setString(3, endDate);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<Order> doRetrieveAll() 
    {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY order_date DESC";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<Order> doRetrieveByDateRange(String startDate, String endDate) 
    {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE order_date BETWEEN ? AND ?";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, startDate);
            ps.setString(2, endDate);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    private Order mapOrder(ResultSet rs) throws SQLException 
    {
        Order o = new Order();

        o.setId(rs.getInt("id"));
        o.setUserId(rs.getInt("user_id"));
        o.setDataOrdine(rs.getTimestamp("order_date"));
        o.setTotale(rs.getDouble("total"));
        o.setIndirizzoSpedizione(rs.getString("shipping_address"));
        o.setMetodoPagamento(rs.getString("payment_method"));
        o.setStato(rs.getString("status"));

        return o;
    }
}
