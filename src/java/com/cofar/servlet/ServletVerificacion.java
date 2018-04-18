/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.servlet;

import com.cofar.bean.util.correos.EnvioCorreoDesviacionBajoRendimiento;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author hvaldivia
 */
public class ServletVerificacion extends HttpServlet {
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        System.out.println("holas");
        PrintWriter out = response.getWriter();
        Logger LOGGER=LogManager.getRootLogger();
        try {
            
            int codDesviacion=Integer.valueOf(request.getParameter("codDesviacion"));
            LOGGER.info("inicio envio correo desviacion zeus "+codDesviacion);
            
            if(codDesviacion>0)
            {
                EnvioCorreoDesviacionBajoRendimiento correoBajoRendimiento=new EnvioCorreoDesviacionBajoRendimiento(codDesviacion,request.getSession().getServletContext());
                correoBajoRendimiento.start();
            }
            LOGGER.info("termino envio correo desviacion zeus "+codDesviacion);
            out.println("atlas termino envio correo");
        } finally {
            out.close();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
