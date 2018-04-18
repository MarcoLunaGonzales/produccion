/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.servlet;

import com.lowagie.text.Document;
import com.lowagie.text.pdf.AcroFields;
import com.lowagie.text.pdf.PdfCopy;
import com.lowagie.text.pdf.PdfReader;
import com.lowagie.text.pdf.PdfStamper;
import com.lowagie.text.pdf.PdfWriter;
import com.lowagie.text.pdf.RandomAccessFileOrArray;
import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author aquispe
 */
public class MostrarDocumento extends HttpServlet {

    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try
        {
         boolean impresion=request.getParameter("i").equals("1");
         boolean guardar=request.getParameter("g").equals("1");
        String direccion1 = request.getSession().getServletContext().getRealPath("biblioteca/documentosBiblioteca/documentosBiblioteca/");
        String direccion=request.getParameter("srce");
        response.setContentType("application/pdf");
        PdfReader reader = new PdfReader(direccion1+"\\"+direccion);
        PdfStamper stamper = new PdfStamper(reader,response.getOutputStream());
        if(!guardar)
        {
            

            if(impresion)
            {System.out.println("solo imprimir");
             stamper.setEncryption(null, "pwd_permisos".getBytes(),PdfWriter.ALLOW_PRINTING, PdfWriter.STRENGTH128BITS);
                stamper.setViewerPreferences(PdfWriter.HideMenubar | PdfWriter.HideToolbar|PdfWriter.ALLOW_FILL_IN|PdfWriter.PageLayoutOneColumn);
               
            //
            }
            else
            {
                System.out.println("solo lectura");
                stamper.setEncryption(null, "pwd_permisos".getBytes(),0, PdfWriter.STRENGTH128BITS);
                stamper.setViewerPreferences(PdfWriter.HideWindowUI|PdfCopy.HideMenubar|PdfCopy.HideToolbar|PdfWriter.HideMenubar | PdfWriter.HideToolbar |PdfWriter.ALLOW_FILL_IN|PdfWriter.PageLayoutOneColumn);
                
            }
        }
        else
        {
            stamper.setViewerPreferences(PdfWriter.PageLayoutOneColumn|PdfWriter.PageModeUseOutlines);
        }
        stamper.setFullCompression();
        stamper.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        /*
        String direccion1 = request.getSession().getServletContext().getRealPath("biblioteca/documentosBiblioteca/documentosBiblioteca/");
        String direccion=request.getParameter("srce");


        OutputStream ouputStream = response.getOutputStream();
        PdfReader reader = null;
        RandomAccessFileOrArray letter;
        ByteArrayOutputStream baos;
        try {
            letter = new RandomAccessFileOrArray(direccion1 + "\\" + direccion);
            reader = new PdfReader(letter, null);
            baos = new ByteArrayOutputStream();
            
            reader = new PdfReader(baos.toByteArray());
            Document document = new Document(reader.getPageSizeWithRotation(1));
            PdfCopy writer = new PdfCopy(document, response.getOutputStream());
            PdfStamper stamper=new PdfStamper(reader,response.getOutputStream());
            stamper.setEncryption(null, "cofarDocumentos2013*".getBytes(),0, PdfWriter.STRENGTH128BITS);
            stamper.setViewerPreferences(PdfWriter.HideMenubar | PdfWriter.HideToolbar );//|PdfWriter.ALLOW_COPY | PdfWriter.AllowFillIn | PdfWriter.AllowAssembly
            stamper.setFullCompression(); //COMPRIME EL TAMAÑO DEL PDF
            stamper.close();
            //new FileOutputStream("d://FormularioLLenoPDF.pdf"));
            document.open();
            //for(int i=1;i<reader.getNumberOfPages();i++){
            //writer.addPage(writer.getImportedPage(reader,1));
            //}
            document.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }*/


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
