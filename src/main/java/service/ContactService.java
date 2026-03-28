package service;

import java.util.List;

import model.Contact;
import dao.admin.ContactAdminDao;

public class ContactService {

    private final ContactAdminDao contactAdminDao = new ContactAdminDao();

    public List<Contact> getAllContact() {
        return contactAdminDao.getAllContact();
    }

    public List<Contact> getAllContactByStatus(String status) {
        return contactAdminDao.getAllContactByStatus(status);
    }

    public Contact getContactById(int id) {
        return contactAdminDao.getContactById(id);
    }

    public void acceptContact(int id) {
        contactAdminDao.acceptContact(id, "Closed");
    }

    public void deleteContact(int id) {
        contactAdminDao.deleteContact(id);
    }
}
