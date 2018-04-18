
package com.cofar.servlet;
import com.lowagie.text.Chunk;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.Image;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.Barcode128;
import com.lowagie.text.pdf.Barcode39;
import com.lowagie.text.pdf.BarcodeCodabar;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import java.awt.Color;
import java.io.*;
import java.net.*;

import javax.servlet.*;
import javax.servlet.http.*;

/**
 *
 * @author Wilson Choquehuanca Gonzales
 * @version
 */
public class barcode extends HttpServlet {
    
    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String locationString=request.getParameter("location");
        String numberString=request.getParameter("number");
        System.out.println("location:"+locationString);
        System.out.println("number:"+numberString);
        /* Revisamos que recibimos los parametros que necesitamos */
        if(request.getParameter("location").length()<=0){
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("Required parameter location is missing.");
            out.close();
            return;
        }
        if(request.getParameter("number").length()<=0 || Integer.parseInt(request.getParameter("number")) <= 0){
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("Required parameter number is missing.");
            out.close();
            return;
        }
        
        int number = Integer.parseInt(request.getParameter("number")); // recibimos los parametros que necesitamos.
        String location = request.getParameter("location");
        String prior = "0";
        String value = new String(""+System.currentTimeMillis());//tomamos el tiempo porque es un numero que no se repite.
        System.out.println("value:::::::::::::"+value);
        //String value = "1";
        File temp = File .createTempFile( location+value, ".tmp", new File( "C:\\temp\\" ) ); //creamos un archivo temporal
        temp.deleteOnExit();// Arreglamos para que se borren al salir.
        
        Document document = new Document();
        //la escritura del pdf la haremos dentro de try para capturar errores.
        
        try {
            PdfWriter writer = PdfWriter.getInstance(document, new FileOutputStream(temp));
            document.open();
            PdfContentByte cb = writer.getDirectContent();
            /* Empezamos a usar itext para crear una tabla. */
            PdfPTable page = new PdfPTable(1);    //tres columnas
            page.getDefaultCell().setPadding(0f); //sin espacios
            page.getDefaultCell().setBorder(Rectangle.NO_BORDER);//sin bordos
            page.getDefaultCell().setHorizontalAlignment(Element.ALIGN_LEFT);//alineado de izquierda a derecha
            page.setWidthPercentage(110f);
            /* Ciclo para generar cada codigo de barras, sin repetir el contenido*/
            int a = 0;
            System.out.println("number for antes:"+number);
            for(int i = 0; i<number;i++){
                System.out.println("number in for:"+i);
                PdfPTable cell = new PdfPTable(1);//hacemos una tabla para el codigo que haremos
                cell.getDefaultCell().setBorder(Rectangle.NO_BORDER);//sin borde
                cell.getDefaultCell().setPadding(40f); //medidas solicitadas
                //Wilson aqui se puede cambiar el tipo de codificacionn de codigos de barra
                Barcode128 shipBarCode = new Barcode128();//usamos la clase Barcode128 de iText para generar la imagen
                shipBarCode.setX(1f);//puedes modificar estas medidas para que veas como queda tu codigo de barras (mas grande, mas ancho, etcetera)
                shipBarCode.setN(0.5f);
                shipBarCode.setChecksumText(true);
                shipBarCode.setGenerateChecksum(true);
                shipBarCode.setSize(5f);
                shipBarCode.setTextAlignment(Element.ALIGN_CENTER);//alineado al centro
                shipBarCode.setBaseline(9f);
                //value = new String(""+System.currentTimeMillis());
                value=" ";
                System.out.println("value:"+value);
                if(a >9){//cada 9 codigos generamos un consecutivo
                    String ax = new String(""+System.currentTimeMillis());
                    System.out.println("ax:"+ax);
                    while(value.substring(1,value.length()-0).equals(ax.substring(1,ax.length()-3))){//nos ciclamos hasta que el tiempo cambie.
                        ax = new String(""+System.currentTimeMillis());
                    }
                    a = 0;
                    ax="";
                    value = ax;
                }
                System.out.println("locartion:salir:"+location);
                shipBarCode.setCode(location);//este es el valor que tendra el codigo de barras.
                a++;
                shipBarCode.setBarHeight(40f);//altura del codigo de barras
                
                Image imgShipBarCode = shipBarCode.createImageWithBarcode(cb, Color.black, Color.BLACK);// convertimos este codigo en una imagen
                Chunk cbc = new Chunk(imgShipBarCode, 0, 0);//la imagen del codigo de barras la ponemos en un chunk
                
                Phrase p = new Phrase(cbc);//este chunk lo ponemos en un phrase.
                System.out.println(" shipBarCode.setCode(location):"+ shipBarCode.getCode());
                
                PdfPCell c = new PdfPCell(p); //creamos una celda que contenga la frase P
                
                c.setPaddingTop(0f); //medidas necesarias
                c.setPaddingBottom(0f);
                c.setPaddingLeft(0f);
                c.setPaddingRight(0f);
                c.setBorder(Rectangle.NO_BORDER);
                c.setVerticalAlignment(Element.ALIGN_TOP);
                c.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.addCell(c);//acregamos la celda a la tabla
                page.addCell(cell); //la tabla a la tabla principal
            }//seguimos en el ciclo!
            System.out.println("paso:1");
            document.add(page);
            System.out.println("paso:2");
            document.close();
            System.out.println("paso:3");
            
            response.setContentType("application/pdf");
            OutputStream out = response.getOutputStream();
            System.out.println("paso:4");
            FileInputStream FOS = new FileInputStream(temp);
            
            while (FOS.available() > 0)
                out.write(FOS.read());
            
        } catch (FileNotFoundException ex) {
            System.out.println("catch 1:");
            ex.printStackTrace();
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println(ex.getMessage());
            out.close();
        } catch (DocumentException ex) {
            System.out.println("catch 2:");
            ex.printStackTrace();
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println(ex.getMessage());
            out.close();
        }
        
        
        
        
        
        
        
        
        
        
    }
    
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    
    /** Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    
    /** Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Short description";
    }
    // </editor-fold>
}
