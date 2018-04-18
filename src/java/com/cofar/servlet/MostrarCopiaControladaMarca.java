/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.servlet;


import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.FontFactory;
import com.lowagie.text.Image;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.ColumnText;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfCopy;
import com.lowagie.text.pdf.PdfGState;
import com.lowagie.text.pdf.PdfImportedPage;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfPage;
import com.lowagie.text.pdf.PdfReader;
import com.lowagie.text.pdf.PdfStamper;
import com.lowagie.text.pdf.PdfTemplate;
import com.lowagie.text.pdf.PdfTextArray;
import com.lowagie.text.pdf.PdfWriter;

import com.lowagie.text.pdf.codec.TiffImage;

import java.awt.Color;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author DASISAQ-
 */
public class MostrarCopiaControladaMarca extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        System.out.println("iniciando abrir documento");
        try {
           String direccion1 = request.getSession().getServletContext().getRealPath("controlMarcasProducto/certificadosPdf/");
            String direccion=request.getParameter("srce");
            System.out.println("abriendo Documento "+direccion);
            response.setContentType("application/pdf");
            System.out.println(direccion1+File.separator+direccion);
            PdfReader reader = new PdfReader(direccion1+File.separator+direccion);
            PdfStamper stamp = new PdfStamper(reader,response.getOutputStream());
            int i = 0;
            PdfContentByte add_watermark;
            PdfGState gs = new PdfGState();
            gs.setFillOpacity(0.6f);
            Rectangle tamPagina=reader.getPageSizeWithRotation(1);
            int number_of_pages = reader.getNumberOfPages();
            while (i < number_of_pages) {
              i++;
            add_watermark = stamp.getOverContent(i);
            add_watermark.saveState();
            add_watermark.beginText();
            BaseFont bf1 = BaseFont.createFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
            add_watermark.setFontAndSize(bf1, 12);
            add_watermark.stroke();
            add_watermark.endText();
            add_watermark.setGState(gs);
            add_watermark.beginText();
            BaseFont bf = BaseFont.createFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
            add_watermark.setFontAndSize(bf,46);
            add_watermark.setColorFill(Color.LIGHT_GRAY);
            
            float anchoDiag =(float)Math.sqrt(Math.pow((tamPagina.getHeight() - 120), 2)+ Math.pow((tamPagina.getWidth() - 60), 2));
            float porc =(float)100 * (anchoDiag / bf.getWidthPoint("COPIA CONTROLADA", 46));
            add_watermark.setHorizontalScaling(porc);
            double angPage = (-1)* Math.atan((tamPagina.getHeight() - 60) / (tamPagina.getWidth() - 60));
            add_watermark.setTextMatrix((float)Math.cos(angPage), (float)Math.sin(angPage),(float)((-1F) * Math.sin(angPage)),(float)Math.cos(angPage),30F,(float)tamPagina.getHeight()- 60);
            add_watermark.fill();
            add_watermark.showText("COPIA CONTROLADA");
            add_watermark.endText();
            }
            stamp.close();
       
        }catch(Exception ex)
        {
            ex.printStackTrace();
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
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
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
