package org.openmrs.module.patientdashboardapp.model;

import java.util.Date;

import org.openmrs.Order;

public class LabOrderViewModel {
	private Integer orderId;
	private Integer patientId;
	private String orderName;
	private Date orderDate;
	private String orderer;
	
	public LabOrderViewModel(Order order) {
		orderId = order.getId();
		orderName = order.getConcept().getDisplayString();
		orderDate = order.getEffectiveStartDate();
		orderer = order.getCreator().getDisplayString();
		patientId = order.getPatient().getId();
	}

	public Integer getOrderId() {
		return orderId;
	}

	public void setOrderId(Integer orderId) {
		this.orderId = orderId;
	}

	public Integer getPatientId() {
		return patientId;
	}

	public void setPatientId(Integer encounterId) {
		this.patientId = encounterId;
	}

	public String getOrderName() {
		return orderName;
	}

	public void setOrderName(String orderName) {
		this.orderName = orderName;
	}

	public Date getOrderDate() {
		return orderDate;
	}

	public void setOrderDate(Date orderDate) {
		this.orderDate = orderDate;
	}

	public String getOrderer() {
		return orderer;
	}

	public void setOrderer(String orderer) {
		this.orderer = orderer;
	}
}
