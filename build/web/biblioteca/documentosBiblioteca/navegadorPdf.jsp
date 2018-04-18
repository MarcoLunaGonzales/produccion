<%@page import="javax.servlet.*"%>
<%@page import="javax.servlet.http.*" %>
<%@page import="java.io.*" %>
<%@page import="java.util.*" %>
<%@page import="com.lowagie.text.pdf.*" %>
<%@page import="com.lowagie.text.*" %>
    <%--script>
       
        function imprimir()
        {
           var pdf = document.getElementById("pdf");
           
            pdf.close();
        }
        com
        function tecla(){
  alert('TECLADO BLOQUEADO')};
  document.onkeydown=tecla;
  document.onmousedown=tecla;

    </script--%>
    <%
    //String direccion1 = request.getSession().getServletContext().getRealPath("biblioteca/documentosBiblioteca/documentosBiblioteca/");
    //String direccion=request.getParameter("srce");

    //PdfReader reader=new PdfReader((direccion1+"\\"+direccion));
    
    /*PdfStamper stamper=new PdfStamper(reader,new FileOutputStream("D:/img.pdf"));
    stamper.setEncryption(null, "pwd_permisos".getBytes(),0, PdfWriter.STRENGTH128BITS);
    stamper.setViewerPreferences(PdfWriter.HideMenubar | PdfWriter.HideToolbar );//|PdfWriter.ALLOW_COPY | PdfWriter.AllowFillIn | PdfWriter.AllowAssembly
    stamper.setFullCompression(); //COMPRIME EL TAMAÑO DEL PDF
    stamper.close();*/
   /* response.setContentType("application/pdf");
    RandomAccessFileOrArray letter=new RandomAccessFileOrArray((direccion1+"\\"+direccion));
    PdfReader reader=new PdfReader(letter,null);
    ByteArrayOutputStream baos=new  ByteArrayOutputStream();
    PdfStamper  stamper=new PdfStamper(reader,baos );
    AcroFields form=stamper.getAcroFields();
    stamper.close();
    reader=new PdfReader(baos.toByteArray());
    Document document=new Document(reader.getPageSizeWithRotation(1));
    PdfCopy writer=new PdfCopy(document,response.getOutputStream());//
    document.open();
    System.out.println("hhhs");

    writer.addPage(writer.getImportedPage(reader, 1));
    document.close();*/
    String direccion1 = request.getSession().getServletContext().getRealPath("biblioteca/documentosBiblioteca/documentosBiblioteca/");

    String direccion=request.getParameter("srce");
        response.setContentType("application/pdf");
        //response.setHeader("Content-Disposition", "attachment; filename=pdf.pdf");

       PdfReader reader = new PdfReader(direccion1+"\\"+direccion); //Crea lector de PDF
        PdfStamper stamper = new PdfStamper(reader, new FileOutputStream("D:\\pdf\\sss.pdf"));
        // contraseña de apertura | contraseña de permisos (impresion)
        stamper.setEncryption(null, "pwd_permisos".getBytes(),0, PdfWriter.STRENGTH128BITS);
        stamper.setViewerPreferences(PdfWriter.HideMenubar | PdfWriter.HideToolbar |PdfWriter.ALLOW_COPY|PdfWriter.ALLOW_FILL_IN);
        stamper.setFullCompression(); //COMPRIME EL TAMAÑO DEL PDF
        stamper.close();

    %>
   
