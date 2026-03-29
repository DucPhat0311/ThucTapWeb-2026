package dao.admin;

import java.util.List;

import model.Contact;
import dao.core.BaseDao;

public class ContactAdminDao extends BaseDao {

     public List<Contact> getAllContact() {
        return getJdbi().withHandle(handle -> handle.createQuery("""
                SELECT *
                FROM contacts""")
                .mapToBean(Contact.class)
                .list());
    }

    public List<Contact> getAllContactByStatus(String status) {
        return getJdbi().withHandle(handle -> handle.createQuery("""
                SELECT *
                FROM contacts
                WHERE status = :status""")
                .bind("status",status)
                .mapToBean(Contact.class)
                .list());
    }

    public Contact getContactById(int id) {
        return getJdbi().withHandle(handle -> handle.createQuery("""
                SELECT *
                FROM contacts
                WHERE id = :id""")
                .bind("id", id)
                .mapToBean(Contact.class)
                .findOne()
                .orElse(null));
    }


    public void acceptContact(int id, String status) {
        getJdbi().withHandle(handle -> handle.createUpdate("""
                UPDATE contacts
                SET status = :status
                WHERE id = :id""")
                .bind("id", id)
                .bind("status", status)
                .execute());
    }

    public void deleteContact(int id) {
        getJdbi().withHandle(handle -> handle.createUpdate("""
                DELETE FROM contacts WHERE id = :id""")
                .bind("id", id)
                .execute());
    }
    public void updateContact(Contact contact) {
        getJdbi().withHandle(handle -> handle.createUpdate("""
                UPDATE contacts
                SET 
                    name = :name,
                    email = :email,
                    phone = :phone,
                    message = :message,
                    address = :address,
                    status = :status
                WHERE id = :id""")
                .bind("name", contact.getName())
                .bind("email", contact.getEmail())
                .bind("phone", contact.getPhone())
                .bind("message", contact.getMessage())
                .bind("address", contact.getAddress())
                .bind("status", contact.getStatus())
                .bind("id", contact.getId())
                .execute());
    }
}
