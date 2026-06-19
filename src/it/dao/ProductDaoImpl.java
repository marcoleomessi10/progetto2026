package it.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import it.model.Product;

public class ProductDaoImpl implements ProductDao {

    private DataSource ds;

    public ProductDaoImpl(DataSource ds) 
    {
        this.ds = ds;
    }

    @Override
    public List<Product> doRetrieveAll() 
    {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE active = TRUE";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Product p = new Product();

                p.setId(rs.getInt("id"));
                p.setNome(rs.getString("name"));
                p.setDescrizione(rs.getString("description"));
                p.setMarca(rs.getString("brand"));
                p.setPrezzo(rs.getDouble("price"));
                p.setQuantitaDisponibile(rs.getInt("stock"));
                p.setCategoria(rs.getString("category"));
                p.setImmagine(rs.getString("image"));
                p.setAttivo(rs.getBoolean("active"));
                p.setDataCreazione(rs.getTimestamp("created_at"));

                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<Product> doRetrieveAllForAdmin() 
    {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY id DESC";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Product p = new Product();

                p.setId(rs.getInt("id"));
                p.setNome(rs.getString("name"));
                p.setDescrizione(rs.getString("description"));
                p.setMarca(rs.getString("brand"));
                p.setPrezzo(rs.getDouble("price"));
                p.setQuantitaDisponibile(rs.getInt("stock"));
                p.setCategoria(rs.getString("category"));
                p.setImmagine(rs.getString("image"));
                p.setAttivo(rs.getBoolean("active"));
                p.setDataCreazione(rs.getTimestamp("created_at"));

                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public Product doRetrieveById(int id) 
    {
        String sql = "SELECT * FROM products WHERE id = ?";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Product p = new Product();

                p.setId(rs.getInt("id"));
                p.setNome(rs.getString("name"));
                p.setDescrizione(rs.getString("description"));
                p.setMarca(rs.getString("brand"));
                p.setPrezzo(rs.getDouble("price"));
                p.setQuantitaDisponibile(rs.getInt("stock"));
                p.setCategoria(rs.getString("category"));
                p.setImmagine(rs.getString("image"));
                p.setAttivo(rs.getBoolean("active"));
                p.setDataCreazione(rs.getTimestamp("created_at"));

                return p;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public List<Product> doRetrieveByName(String name) 
    {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE name LIKE ? AND active = TRUE";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + name + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Product p = new Product();

                p.setId(rs.getInt("id"));
                p.setNome(rs.getString("name"));
                p.setMarca(rs.getString("brand"));
                p.setPrezzo(rs.getDouble("price"));
                p.setCategoria(rs.getString("category"));
                p.setImmagine(rs.getString("image"));

                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<Product> doRetrieveByCategory(int categoryId) 
    {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE category = (SELECT name FROM categories WHERE id = ?) AND active = TRUE";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Product p = new Product();

                p.setId(rs.getInt("id"));
                p.setNome(rs.getString("name"));
                p.setMarca(rs.getString("brand"));
                p.setPrezzo(rs.getDouble("price"));
                p.setCategoria(rs.getString("category"));
                p.setImmagine(rs.getString("image"));

                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public void doSave(Product p) 
    {
        String sql = "INSERT INTO products "
                + "(name, description, brand, price, category, quantity, stock, image, image_path, active) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, p.getNome());
            ps.setString(2, p.getDescrizione());
            ps.setString(3, p.getMarca());
            ps.setDouble(4, p.getPrezzo());
            ps.setString(5, p.getCategoria());
            ps.setInt(6, p.getQuantitaDisponibile());
            ps.setInt(7, p.getQuantitaDisponibile());
            ps.setString(8, p.getImmagine());
            ps.setString(9, "images/" + p.getImmagine());
            ps.setBoolean(10, p.isAttivo());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void doUpdate(Product p) 
    {
        String sql = "UPDATE products SET "
                + "name = ?, description = ?, brand = ?, price = ?, category = ?, quantity = ?, "
                + "stock = ?, image = ?, image_path = ?, active = ? "
                + "WHERE id = ?";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, p.getNome());
            ps.setString(2, p.getDescrizione());
            ps.setString(3, p.getMarca());
            ps.setDouble(4, p.getPrezzo());
            ps.setString(5, p.getCategoria());
            ps.setInt(6, p.getQuantitaDisponibile());
            ps.setInt(7, p.getQuantitaDisponibile());
            ps.setString(8, p.getImmagine());
            ps.setString(9, "images/" + p.getImmagine());
            ps.setBoolean(10, p.isAttivo());
            ps.setInt(11, p.getId());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void updateQuantity(int productId, int quantity) 
    {
        String sql = "UPDATE products SET quantity = ?, stock = ? WHERE id = ?";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, quantity);
            ps.setInt(2, quantity);
            ps.setInt(3, productId);

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void doDelete(int id) 
    {
        String sql = "UPDATE products SET active = FALSE WHERE id = ?";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
