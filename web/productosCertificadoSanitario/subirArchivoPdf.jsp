<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page  import="javazoom.upload.*,java.util.*,java.io.*" %>
<%@ page  import="jxl.*" %>
<%@ page  import="jxl.Sheet" %>
<%@ page  import="jxl.Workbook" %>
<%@ page import="java.text.*" %>
<%
    String direccion = request.getSession().getServletContext().getRealPath("productosCertificadoSanitario/certificadosPdf/");
%>
<jsp:useBean id="upBean" scope="page" class="javazoom.upload.UploadBean" >
        <jsp:setProperty name="upBean" property="folderstore" />
        <jsp:setProperty name="upBean" property="folderstore" value="<%=direccion%>" />
    <jsp:setProperty name="upBean" property="whitelist" value="*.jpg,*.gif,*.pdf" />
    <jsp:setProperty name="upBean" property="overwritepolicy" value="nametimestamp"/>
    </jsp:useBean>

<%
String codCompprod=request.getParameter("codComprod");

if (MultipartFormDataRequest.isMultipartFormData(request)) {
 MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
 String todo = null;
 if (mrequest != null) {
  todo = mrequest.getParameter("todo");
 }
 if ((todo != null) && (todo.equalsIgnoreCase("upload"))) {
  Hashtable files = mrequest.getFiles();
  if ((files != null) && (!files.isEmpty())) {
   //java.text.SimpleDateFormat formato = new java.text.SimpleDateFormat("yyMMddHHmmss");
   String archivo = ((UploadFile) mrequest.getFiles().get("uploadfile")).getFileName();
   int posicionPunto = archivo.indexOf(".");
    System.out.println("hola1");
    SimpleDateFormat sdf1=new SimpleDateFormat("dd-MM-yyyy HH-mm");
 //  SimpleDateFormat sdfddd=new SimpleDateFormat("dd-MM-YYYY");
   System.out.println("hola2");
   String nombreImagen = archivo.substring(0, posicionPunto);
   String extension = archivo.substring(posicionPunto);
   
   nombreImagen = nombreImagen ;//+ formato.format(new java.util.Date())
   codCompprod=mrequest.getParameter("codComprod");
   nombreImagen+="-cp-"+codCompprod+"-f-"+sdf1.format(new Date());
   nombreImagen = nombreImagen + extension;
   ((UploadFile) mrequest.getFiles().get("uploadfile")).setFileName(nombreImagen);
   UploadFile file = (UploadFile) files.get("uploadfile");
   if (file != null) {
    try{
       Connection con=null;
       con=Util.openConnection(con);
       
       System.out.println("codComp "+codCompprod);
       String consulta=" update COMPONENTES_PROD set DIRECCION_ARCHIVO_REGISTRO_SANITARIO='"+file.getFileName()+"' where cod_compprod='"+codCompprod+"'";
       System.out.println("consulta update "+consulta);
       PreparedStatement pst=con.prepareStatement(consulta);
       if(pst.executeUpdate()>0)System.out.println("se registro la direccion del archivo");
       pst.close();
       con.close();
    }
    catch(SQLException ex)
    {
        ex.printStackTrace();
    }
    
    out.println("<script>alert('El archivo se subio correctamente');parent.ocultaRegistro();parent.refrescar();</script>");
   }
   upBean.store(mrequest, "uploadfile");
  }
  else {
    out.println("Archivos no subidos");
  }
 } else {
   out.println("<BR> todo=" + todo);
 }
}
%>
<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
        
    </head>
    <body style="border:none" bgcolor="#eeeeee"><br><br>
        <h3 align="center"></h3>
        <center>
        <table bgcolor="#ffffff" style=" border:solid black 1px;">
            <%
            Connection con=null;
            try
                    {
                con=Util.openConnection(con);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                String consulta=" select cp.nombre_prod_semiterminado,f.nombre_forma,ae.NOMBRE_AREA_EMPRESA,"+
                                " cp.NOMBRE_GENERICO,cp.FECHA_VENCIMIENTO_RS,cp.REG_SANITARIO,ep.nombre_estado_prod"+
                                " from COMPONENTES_PROD cp inner join FORMAS_FARMACEUTICAS f on cp.COD_FORMA = f.cod_forma"+
                                " inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA = cp.COD_AREA_EMPRESA"+
                                " inner join estados_producto ep on ep.cod_estado_prod =cp.COD_ESTADO_COMPPROD"+
                                " where cp.COD_COMPPROD='"+codCompprod+"'";
                System.out.println("consulta prod "+consulta);
                ResultSet res=st.executeQuery(consulta);
                if(res.next())
                    {
            %>
            <tr class="headerClassACliente"> <td style="font-weight:bold" align="center" colspan="6" class="outputText2" >Datos del Producto Semiterminado</td></tr>
            <tr> <td style="font-weight:bold" class="outputText2">Nombre Producto</td>
            <td style="font-weight:bold" class="outputText2">::</td>
            <td  class="outputText2"><%=res.getString("nombre_prod_semiterminado")%></td>
            <td style="font-weight:bold" class="outputText2">Estado Producto</td>
            <td style="font-weight:bold" class="outputText2">::</td>
            <td  class="outputText2"><%=res.getString("nombre_estado_prod")%></td>
            </tr>
            <tr> <td style="font-weight:bold" class="outputText2">Forma Farmaceútica</td>
            <td style="font-weight:bold" class="outputText2">::</td>
            <td  class="outputText2"><%=res.getString("nombre_forma")%></td>
            <td style="font-weight:bold" class="outputText2">Area de Fabricación</td>
            <td style="font-weight:bold" class="outputText2">::</td>
            <td  class="outputText2"><%=res.getString("NOMBRE_AREA_EMPRESA")%></td>
            </tr>
            <tr> <td style="font-weight:bold" class="outputText2">Nombre Genérico</td>
            <td style="font-weight:bold" class="outputText2">::</td>
            <td  class="outputText2"><%=res.getString("NOMBRE_GENERICO")%></td>
            <td style="font-weight:bold" class="outputText2">Registro Sanitario</td>
            <td style="font-weight:bold" class="outputText2">::</td>
            <td  class="outputText2"><%=res.getString("REG_SANITARIO")%></td>
            </tr>
            <%
                }
                res.close();
                st.close();
                con.close();
                }
            catch(SQLException ex)
            {
                ex.printStackTrace();
            }
            %>
        </table>
        </center>
        <form name="upform" method="post" action="subirArchivoPdf.jsp" enctype="multipart/form-data">
            <div align="center">
              <table style="border:solid 1px black;width:80%" bgcolor="#ffffff" class="dr-table rich-table" border="0" cellpadding="2"cellspacing="2">
                  <tbody>
                      <tr class='dr-table-subheader rich-table-subheader'>
                          <td colspan="2" class="outputText2 dr-table-subheadercell rich-table-subheadercell headerClassACliente" style="font-size:12;font-weight:bold" ><center>Subir Certificado Registro Sanitario</center></td>
                          
                      </tr>
                      <tr>
                          <td class="outputText2">Archivo:</td>
                          <td><input type="file" name="uploadfile" style="width:420px;" /> </td>
                      </tr>
                      <tr>
                          
                          <td colspan="2">
                              <center><input type="hidden" name="todo" value="upload">
                                      <input type="submit" class="btn" value="Aceptar">
                                      <button class="btn" onclick="parent.ocultaRegistro();">Cancelar</button>
                              </center>
                          </td>
                          
                      </tr>
                  </tbody>
              </table>

            </div>
            <input type="hidden" value="<%=codCompprod%>" name="codComprod" id="codComprod"/>
            
        </form>
        
    </body>
</html>