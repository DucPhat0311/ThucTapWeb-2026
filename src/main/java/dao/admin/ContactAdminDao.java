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

}
