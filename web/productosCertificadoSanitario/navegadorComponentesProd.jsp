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
<%@ page  import="javazoom.upload.*,java.util.*,java.io.*" %>
<%@ page  import="jxl.*" %>
<%@ page  import="jxl.Sheet" %>
<%@ page  import="jxl.Workbook" %>
<%@ page import="java.text.*" %>

<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
        <script>
            function mostarSubirArchivo(codComprod)
            {
                var aleatorio=Math.random();
                window.location="subirArchivoPdf.jsp?codComprod="+codComprod+"&cod="+aleatorio;
            }
        </script>
    </head>
    <body><br><br>
        <h3 align="center">Subir Certificado Registro Sanitario</h3>
           <center> <table>
                <tr>
                    <td class="outputText2">Productos con Certificado</td>
                    <td style="width:70px" bgcolor="#90EE90"></td>
                </tr>
            </table>
            </center>
        <form  method="post" action="navegadorComponentesProd.jsf" >
            <div align="center">
              <table border="1"  class="dr-table rich-table" style="border-bottom:1px;border-right:1px;border-color:black" cellpadding="0"cellspacing="0" border="1s">
                  <%
                  try
                  {
                      Connection con=null;
                      con=Util.openConnection(con);
                      Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                      String consulta="select isnull(cp.DIRECCION_ARCHIVO_REGISTRO_SANITARIO,'') as DIRECCION_ARCHIVO_REGISTRO_SANITARIO,cp.cod_compprod,cp.nombre_prod_semiterminado,ff.nombre_forma,ae.NOMBRE_AREA_EMPRESA"+
                                      " ,cp.NOMBRE_GENERICO from COMPONENTES_PROD cp inner join FORMAS_FARMACEUTICAS ff on "+
                                     " ff.cod_forma=cp.COD_FORMA inner join AREAS_EMPRESA ae on "+
                                     " ae.COD_AREA_EMPRESA=cp.COD_AREA_EMPRESA inner join estados_producto ep on "+
                                     " ep.cod_estado_prod=cp.COD_ESTADO_COMPPROD order by cp.nombre_prod_semiterminado,ff.nombre_forma,ae.NOMBRE_AREA_EMPRESA";
                      ResultSet res=st.executeQuery(consulta);
                      out.println("<tr class='dr-table-subheader rich-table-subheader'>" +
                              "<td style='border-top:1px;border-left:1px;border-color:black' class='dr-table-subheadercell rich-table-subheadercell headerClassACliente'> Nombre Producto Semiterminado</td>" +
                              
                              "<td style='border-top:1px;border-left:1px;border-color:black' class='dr-table-subheadercell rich-table-subheadercell headerClassACliente'> Forma Farmaceútica</td>" +
                              "<td style='border-top:1px;border-left:1px;border-color:black' class='dr-table-subheadercell rich-table-subheadercell headerClassACliente'> Área de Fabricación</td>" +
                              "<td style='border-top:1px;border-left:1px;border-color:black' class='dr-table-subheadercell rich-table-subheadercell headerClassACliente'> Subir Certificado <br>Registro Sanitario</td>" +
                              "<td style='border-top:1px;border-left:1px;border-color:black' class='dr-table-subheadercell rich-table-subheadercell headerClassACliente'> Ver Certificado</td>" +
                              "</tr><tbody>");
                      String bgColor="";
                      while(res.next())
                      {
                          bgColor=(res.getString("DIRECCION_ARCHIVO_REGISTRO_SANITARIO").equals("")?"#ffffff":"#90EE90");
                          out.println("<tr class='dr-table-subheadercell rich-table-subheadercell'>" +
                                  "<td style='border-top:1px;border-left:1px;border-color:black' class='dr-table-cell rich-table-cell tituloCampo nocodcompuestoprod' bgColor='"+bgColor+"'>"+res.getString("nombre_prod_semiterminado")+"</td>" +
                                 // "<td class='dr-table-cell rich-table-cell tituloCampo nocodcompuestoprod' bgColor='"+bgColor+"'>"+res.getString("NOMBRE_GENERICO")+"</td>" +
                                  "<td style='border-top:1px;border-left:1px;border-color:black' class='dr-table-cell rich-table-cell tituloCampo nocodcompuestoprod' bgColor='"+bgColor+"'>"+res.getString("nombre_forma")+"</td>" +
                                  "<td style='border-top:1px;border-left:1px;border-color:black' class='dr-table-cell rich-table-cell tituloCampo nocodcompuestoprod' bgColor='"+bgColor+"'>"+res.getString("NOMBRE_AREA_EMPRESA")+"</td>" +
                                  "<td style='border-top:1px;border-left:1px;border-color:black' class='dr-table-cell rich-table-cell tituloCampo nocodcompuestoprod' bgColor='"+bgColor+"' aling='center'><center><a onclick='mostarSubirArchivo("+res.getString("cod_compprod")+")' href='#'onmouseover=''><img title='Subir Certificado Registro Sanitario' src='../img/detalle.jpg'></a></center></td>" +
                                  "<td style='border-top:1px;border-left:1px;border-color:black' class='dr-table-cell rich-table-cell tituloCampo nocodcompuestoprod' bgColor='"+bgColor+"'><a href='certificadosPdf/"+res.getString("DIRECCION_ARCHIVO_REGISTRO_SANITARIO")+"'onmouseover=''>"+res.getString("DIRECCION_ARCHIVO_REGISTRO_SANITARIO")+"</a></td>" +
                                  

                                  "<tr>");
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
                  <tbody>
              </table>

            </div>
            
        </form>
        
    </body>
</html>