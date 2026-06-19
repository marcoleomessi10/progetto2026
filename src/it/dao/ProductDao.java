package it.dao;

import java.util.List;

import it.model.Product;

public interface ProductDao {

    List<Product> doRetrieveAll();

    List<Product> doRetrieveAllForAdmin();

    Product doRetrieveById(int id);

    List<Product> doRetrieveByName(String name);

    List<Product> doRetrieveByCategory(int categoryId);

    void doSave(Product product);

    void doUpdate(Product product);

    void updateQuantity(int productId, int quantity);

    void doDelete(int id);
}
