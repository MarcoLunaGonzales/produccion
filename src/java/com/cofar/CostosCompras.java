/*
 * Demo.java
 *
 * Created on 29 de octubre de 2008, 04:17 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar;


//import com.cofar.bean.PresentacionesProducto;
import com.cofar.bean.PresentacionSalida;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
import jxl.Cell;
import jxl.Range;
import jxl.Sheet;
import jxl.Workbook;
import jxl.read.biff.BiffException;

/**
 * The main demo class which interprets the command line switches in order
 * to determine how to call the demo programs
 * The demo program uses stdout as its default output stream
 */
public class CostosCompras {
    List lista=new ArrayList();
    
    public List read(String file,InputStream stream){
        System.out.println("<<<<----------Ingreso al archivo de Excel----------->>>>");
        try {
            lista.clear();
            System.out.println("stream:"+stream);
            Workbook w=Workbook.getWorkbook(stream);
            Sheet hoja=w.getSheet(0);
            int filas =hoja.getRows();
            System.out.println("filas filas"+filas);
            int cont=0;
            while (cont < filas) {
                System.out.println("filas filas"+filas);  
                PresentacionSalida bean = new PresentacionSalida();
                Cell  c[] =hoja.getRow(cont);                
                bean.setCodLoteProduccion(c[0].getContents());
                lista.add(bean);
                System.out.println("c0:"+c[0].getContents());                
                cont=cont+1;
            }
            w.close();
            System.out.println("termino el proceso");
        } catch (BiffException ex) {
            ex.printStackTrace();
        } catch (IOException ex) {
            ex.printStackTrace();
        }
        return lista;
    }
    
    public static void main(String[] args) {
        try {
            Workbook w=Workbook.getWorkbook(new File("c:\\libro1.xls"));
            Sheet hoja=w.getSheet(0);
            int filas =hoja.getRows();
            System.out.println("filas:"+filas);
            int cont=0;
            while (cont<filas) {                                            
                Cell  c[] =hoja.getRow(cont);
                System.out.println("c0:"+c[0].getContents());
                System.out.println("c1:"+c[1].getContents());
                cont=cont+1;
            }
        } catch (BiffException ex) {
            ex.printStackTrace();
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }
}



