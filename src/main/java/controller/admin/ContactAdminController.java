package controller.admin;

import model.Contact;
import service.ContactService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ContactAdminController", value = "/contactAdmin")
public class ContactAdminController extends HttpServlet {
    private ContactService contactService;

    @Override
    public void init() {
        contactService = new ContactService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String mode = request.getParameter("mode");

        if (mode == null) {
            List<Contact> allContacts = contactService.getAllContact();

            int total = allContacts.size();

            int totalNew = contactService.getAllContactByStatus("New").size();
            int totalProcessing = contactService.getAllContactByStatus("Processing").size();
            int totalClosed = contactService.getAllContactByStatus("Closed").size();


            int page = 1;
            int pageSize = 6;
            
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            
            int totalContacts = allContacts.size();
            int totalPages = (int) Math.ceil((double) totalContacts / pageSize);
            
            if (page < 1) page = 1;
            if (page > totalPages && totalPages > 0) page = totalPages;
            
            int start = (page - 1) * pageSize;
            int end = Math.min(start + pageSize, totalContacts);
            List<Contact> contacts = allContacts.subList(start, end);

            request.setAttribute("contacts", contacts);
            request.setAttribute("total", total);
            request.setAttribute("totalContacts", totalContacts);
            request.setAttribute("totalNew", totalNew);
            request.setAttribute("totalProcessing", totalProcessing);
            request.setAttribute("totalClosed", totalClosed);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", pageSize);

            request.setAttribute("page", "contact");
        request.getRequestDispatcher("/WEB-INF/admin/contactAdmin.jsp").forward(request, response);
            return;

        }

        if ("edit".equals(mode) || "view".equals(mode)) {
            int id = Integer.parseInt(request.getParameter("id"));

            Contact contact = contactService.getContactById(id);

            request.setAttribute("contact", contact);
            request.setAttribute("mode", mode);

            request.setAttribute("page", "contact");
        request.getRequestDispatcher("/WEB-INF/admin/form-contactAdmin.jsp").forward(request, response);
            return;
        }

        if ("add".equals(mode)) {
            request.setAttribute("mode", mode);
            request.setAttribute("page", "contact");
        request.getRequestDispatcher("/WEB-INF/admin/form-contactAdmin.jsp").forward(request, response);
            return;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Contact contact = new Contact();

            contact.setId(id);
            contact.setName(request.getParameter("name"));
            contact.setEmail(request.getParameter("email"));
            contact.setPhone(request.getParameter("phone"));
            contact.setStatus(request.getParameter("status"));
            contact.setAddress(request.getParameter("address"));
            contact.setMessage(request.getParameter("message"));

            contactService.updateContact(contact);
            response.sendRedirect("contactAdmin?mode=view&id=" + id);
            return;
        }

        if ("accept".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));

            contactService.acceptContact(id);

            response.sendRedirect("contactAdmin");
            return;
        }

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            contactService.deleteContact(id);
            response.sendRedirect("contactAdmin");
            return;
        }
    }
}


