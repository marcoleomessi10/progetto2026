package it.dao;

import java.util.List;

import it.model.Order;
import it.model.OrderItem;

public interface OrderDao {

    int doSaveOrder(Order order);

    void doSaveOrderItem(OrderItem item);

    Order doRetrieveById(int id);

    List<OrderItem> doRetrieveItemsByOrder(int orderId);

    List<Order> doRetrieveByUser(int userId);

    List<Order> doRetrieveByUserAndDateRange(int userId, String startDate, String endDate);

    List<Order> doRetrieveAll();

    List<Order> doRetrieveByDateRange(String startDate, String endDate);

    void doUpdateStatus(int orderId, String status);
}
