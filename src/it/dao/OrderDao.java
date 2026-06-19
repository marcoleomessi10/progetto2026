package it.dao;

import java.util.List;

import it.model.Order;
import it.model.OrderItem;

public interface OrderDao {

    int doSaveOrder(Order order);

    void doSaveOrderItem(OrderItem item);

    List<Order> doRetrieveByUser(int userId);

    List<Order> doRetrieveAll();

    List<Order> doRetrieveByDateRange(String startDate, String endDate);
}
