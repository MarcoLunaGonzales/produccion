/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.servlet;

import com.cofar.util.Util;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author DASISAQ
 */
public class ServletFirmaCertificadoCC extends HttpServlet {

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
        ServletOutputStream sout = response.getOutputStream();
        Connection con=null;
        try 
        {
            response.setContentType("image/jpeg");
            response.setHeader("Content-Disposition", "inline; filename=imagen.jpg");
            response.setHeader("Cache-control", "public");
            int codPersonal=Integer.valueOf(request.getParameter("codPersonal"));
            
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select f.FIRMA");
                            consulta.append(" from FIRMAS_CERTIFICADO_CC f");
                            consulta.append(" where f.COD_PERSONAL=").append(codPersonal);
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                
                byte[] imagen=null;
                while (res.next()) {
                    imagen=res.getBytes("FIRMA");
                    sout.write(imagen);
                }
                sout.flush();
                
              
                
            } catch (SQLException ex) {
                ex.printStackTrace();
            } catch (Exception ex) {
                ex.printStackTrace();
            } 
            
        }
        finally
        {
            sout.close();
            try
            {
                con.close();
            }catch(Exception ex){ex.printStackTrace();}
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
