<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.text.SimpleDateFormat"%>
<%@ page import = "java.util.ArrayList"%>
<%@ page import = "java.util.Date"%>
<%@ page import = "javax.servlet.http.HttpServletRequest"%>
<%@ page import = "java.text.DecimalFormat"%>
<%@ page import = "java.text.NumberFormat"%>
<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>
<%@ page errorPage="ExceptionHandler.jsp" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../../js/general.js"></script>
        <style>
            .headerLocal{
                    background-image:none;
                    background-color:#9d5f9f;
                    font-weight:bold;
                    border-bottom:1px solid black;
                    border-right:1px solid black;
                    padding:3px;
                }
            .celdaLocal{
                    padding:6px;
                    font-size:12px;
                    border-bottom:1px solid black;
                    border-right:1px solid black;
            }
            .rowClass
            {
                  background-image:none;
                  background-color:#ffffff;
                  font-weight:normal;
            }
            .rowClass:hover
            {
                color:blue;
                background-color:#dddddd;
            }
            .textoCabecera
            {
                font-weight:bold;
                font-size:14px;
            }
           
        </style>
    </head>
    <body>
        <form>
            <%
            String codProgramaProduccionControlCalidad=request.getParameter("codCC");
            String codProgramaControlCalidad=request.getParameter("codProgramaControlCalidad");
            String codProgramaControlCalidadAnalisis=request.getParameter("codProgramaControlCalidadAnalisis");
            String codProducto=request.getParameter("codCompProd");
            String nombreProductoSemiterminado=request.getParameter("nombreProductoSemiterminado");
            String codLoteProduccion=request.getParameter("codLoteProduccion");
            %>
            <center><span class="textoCabecera">INFORME PRODUCTOS EN ESTABILIDAD</span></center>
            <center><span class="textoCabecera">IDENTIFICACION DEL PRODUCTO / FECHA DE ANALISIS</span></center>
            <table align="center">
                <tr><td rowspan="8"><img src="../img/cofar.png" ></td>
            <%
            try{
                Connection con=null;
               con=Util.openConnection(con);
               Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
               String consulta="select cp.nombre_prod_semiterminado,ppcc.COD_LOTE_PRODUCCION,am.NOMBRE_ALMACEN_MUESTRA,pp.COD_FORMULA_MAESTRA,"+
                               " tee.NOMBRE_TIPO_ESTUDIO_ESTABILIDAD,ppcc.CANTIDAD_MUESTRAS,ppcc.TIEMPO_ESTUDIO,"+
                               " tpp.NOMBRE_TIPO_PROGRAMA_PROD,ppp.NOMBRE_PROGRAMA_PROD as programaLoteProduccion,"+
                               " pppcc.NOMBRE_PROGRAMA_PROD"+
                               "  from PROGRAMA_PRODUCCION_CONTROL_CALIDAD ppcc inner join PROGRAMA_PRODUCCION pp on "+
                               " pp.COD_LOTE_PRODUCCION=ppcc.COD_LOTE_PRODUCCION and ppcc.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA"+
                               " and pp.COD_PROGRAMA_PROD=ppcc.COD_PROGRAMA_PROD_LOTE_PRODUCCCION and "+
                               " pp.COD_TIPO_PROGRAMA_PROD=ppcc.COD_TIPO_PROGRAMA_PROD"+
                               " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                               " inner join TIPOS_ESTUDIO_ESTABILIDAD tee on tee.COD_TIPO_ESTUDIO_ESTABILIDAD=ppcc.COD_TIPO_ESTUDIO_ESTABILIDAD"+
                               " inner join ALMACENES_MUESTRA am on am.COD_ALMACEN_MUESTRA=ppcc.COD_ALMACEN_MUESTRA"+
                               " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=ppcc.COD_TIPO_PROGRAMA_PROD"+
                               " inner join PROGRAMA_PRODUCCION_PERIODO ppp on ppp.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD"+
                               " inner join PROGRAMA_PRODUCCION_PERIODO pppcc on pppcc.COD_PROGRAMA_PROD=ppcc.COD_PROGRAMA_PROD" +
                               " where ppcc.COD_PROGRAMA_PROD_CONTROL_CALIDAD='"+codProgramaControlCalidad+"' ";

               System.out.println("consulta cargar cabecera "+consulta);
               ResultSet res=st.executeQuery(consulta);
               SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");

               String codFormulaMAestra="";
               if(res.next())
               {
                   codFormulaMAestra=res.getString("COD_FORMULA_MAESTRA");
                   out.println("<td style='font-weight:bold'>Producto</td><td>::</td><td>"+res.getString("nombre_prod_semiterminado")+"</td><td style='padding-left:12px;font-weight:bold'>Lote Produccion</td><td>::</td><td>"+res.getString("COD_LOTE_PRODUCCION")+"</td></tr>");
                   out.println("<tr><td style='font-weight:bold'>Almacen Muestra</td><td>::</td><td>"+res.getString("NOMBRE_ALMACEN_MUESTRA")+"</td><td style='padding-left:12px;font-weight:bold'>Tipo Estudio</td><td>::</td><td>"+res.getString("NOMBRE_TIPO_ESTUDIO_ESTABILIDAD")+"</td></tr>");
                   out.println("<tr><td style='font-weight:bold'>Cantidad Muestras</td><td>::</td><td>"+res.getString("CANTIDAD_MUESTRAS")+"</td><td style='padding-left:12px;font-weight:bold'>Tiempo de Estudio Programa</td><td>::</td><td>"+res.getString("TIEMPO_ESTUDIO")+"</td></tr>");
                   out.println("<tr><td style='font-weight:bold'>Tipo Programa</td><td>::</td><td>"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"</td><td style='padding-left:12px;font-weight:bold'>Programa Produccion</td><td>::</td><td>"+res.getString("programaLoteProduccion")+"</td></tr>");
                   out.println("<tr><td style='font-weight:bold'>Programa Estadibilidad</td><td>::</td><td>"+res.getString("NOMBRE_PROGRAMA_PROD")+"</td><td style='padding-left:12px;font-weight:bold'>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>");
               }
            }catch(Exception e){e.printStackTrace();}
            %>
            </table>

            <%--table  width="100%"><tr><td>Producto: <%=nombreProductoSemiterminado%></td><td>Lote:  <%=codLoteProduccion%></td></tr>  </table--%>
            
                
            <%
            try
            {
               Connection con=null;
               con=Util.openConnection(con);
               SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
               //SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
               
               String consulta = " select p.FECHA_ANALISIS from PROGRAMA_PRODUCCION_CONTROL_CALIDAD_ANALISIS p where p.COD_PROGRAMA_PROD_CONTROL_CALIDAD = '"+codProgramaControlCalidad+"' ";
               Statement st_2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
               ResultSet rs_2 = st_2.executeQuery(consulta);
               out.print("<table align='center' width='80%'    style='border-top:solid #000000 1px;border-left:solid #000000 1px;margin-top:12px;' class='outputText2' cellspacing='0'>");
               rs_2.last();
               out.print("<tr><td class='celdaLocal'><b>TIEMPO DE MUESTREO</b></td>");
               for(int j =1;j<=rs_2.getRow();j++ ){
                   out.print("<td class='celdaLocal'><b>mes  "+j+"</b></td>");
               }
               out.print("</tr><tr><td class='celdaLocal'><b>FECHA DE ANALISIS</b></td>");
               rs_2.beforeFirst();
               while(rs_2.next()){
                   out.print("<td class='celdaLocal'>"+sdf.format(rs_2.getDate("fecha_analisis"))+"</td>");
               }
               out.print("</tr></table>");


               out.print("<table  align='center' width='80%'    style='border-top:solid #000000 1px;border-left:solid #000000 1px;margin-top:12px;' class='outputText2' cellspacing='0'   >");


               

               Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
               consulta="select f1.COD_ESPECIFICACION,f1.NOMBRE_ESPECIFICACION,f.LIMITE_INFERIOR,f.LIMITE_SUPERIOR,f.DESCRIPCION,f1.COD_TIPO_RESULTADO_ANALISIS,(select count(*) from PROGRAMA_PRODUCCION_CONTROL_CALIDAD_ANALISIS a where a.COD_PROGRAMA_PROD_CONTROL_CALIDAD = '"+codProgramaControlCalidad+"' ) det_control_calidad" +
                        " from ESPECIFICACIONES_FISICAS_PRODUCTO f" +
                        " inner join ESPECIFICACIONES_FISICAS_CC f1 on f.COD_ESPECIFICACION = f1.COD_ESPECIFICACION" +
                        " where f.COD_PRODUCTO = '"+codProducto+"' and f.ESTADO = 1";
               System.out.println("consulta cargar cabecera "+consulta);
               ResultSet res=st.executeQuery(consulta);
               if(res.next()){
                   %>
                   <tr><td colspan="<%=res.getInt("det_control_calidad")+2%>" class='celdaLocal'><center><b>RESULTADOS DE ESTUDIO DE ESTABILIDAD CN</b></center></td></tr>
                   <%
               }
               %>
               <tr><td  class='celdaLocal' style="width:20%"><center><b>FISICO</b></center></td><td class='celdaLocal' style="width:20%" ><center><b>ESPECIFICACION</b></center></td>
               <%
               //para la primera fila
               res.beforeFirst();
               int cont = 1;
               if(res.next()){
                   consulta = " select p.FECHA_ANALISIS,r.COD_TIPO_RESULTADO_DESCRIPTIVO,isnull(t.nombre_tipo_resultado_descriptivo,'') nombre_tipo_resultado_descriptivo,r.resultado_numerico" +
                            " from PROGRAMA_PRODUCCION_CONTROL_CALIDAD_ANALISIS p" +
                           " left outer join resultado_fisico_estabilidad r on r.cod_programa_prod_control_calidad = p.COD_PROGRAMA_PROD_CONTROL_CALIDAD" +
                           " and r.cod_control_calidad_analisis = '"+codProgramaControlCalidadAnalisis+"' and r.cod_especificacion = '"+res.getInt("cod_especificacion")+"'" +
                           " left outer join tipo_resultado_descriptivo t on t.cod_tipo_resultado_descriptivo = r.cod_tipo_resultado_descriptivo " +
                           " where p.COD_PROGRAMA_PROD_CONTROL_CALIDAD = '"+codProgramaControlCalidad+"' and r.cod_tipo_resultado_estabilidad = 1 ";
                   Statement st2 = con.createStatement();
                   ResultSet rs2 = st2.executeQuery(consulta);
                   while(rs2.next()){
                       out.print("<td class='celdaLocal' style='width:15%'><center><b>mes "+cont+"</b></center></td>");
                       cont++;
                   }
               }
               out.print("</tr>");
               res.beforeFirst();

               
               

               Statement st1 = con.createStatement();
               ResultSet rs1 = null;
               while(res.next())
               {
                   out.print("<tr><td class='celdaLocal'><b>"+res.getString("nombre_especificacion")+"</b></td>");
                   out.print("<td class='celdaLocal'><b>&nbsp;"+((res.getDouble("limite_inferior")==0 && res.getDouble("limite_superior")==0)?res.getString("descripcion"):res.getDouble("limite_inferior")+" - "+ res.getDouble("limite_superior"))+"</b></td>");
                   consulta = " select p.FECHA_ANALISIS,r.COD_TIPO_RESULTADO_DESCRIPTIVO,r.resultado_numerico from PROGRAMA_PRODUCCION_CONTROL_CALIDAD_ANALISIS p" +
                           "left outer join resultado_fisico_estabilidad r on r.cod_programa_prod_control_calidad = p.COD_PROGRAMA_PROD_CONTROL_CALIDAD" +
                           "and r.cod_control_calidad_analisis = '' and r.cod_especificacion = ''" +
                           "where p.COD_PROGRAMA_PROD_CONTROL_CALIDAD = 2 ";
                   consulta = " select p.FECHA_ANALISIS,r.COD_TIPO_RESULTADO_DESCRIPTIVO,isnull(t.nombre_tipo_resultado_descriptivo,'') nombre_tipo_resultado_descriptivo,r.resultado_numerico" +
                            " from PROGRAMA_PRODUCCION_CONTROL_CALIDAD_ANALISIS p" +
                           " left outer join resultado_fisico_estabilidad r on r.cod_programa_prod_control_calidad = p.COD_PROGRAMA_PROD_CONTROL_CALIDAD and r.cod_control_calidad_analisis = p.cod_control_calidad_analisis" +
                           " and r.cod_control_calidad_analisis = '"+codProgramaControlCalidadAnalisis+"' and r.cod_especificacion = '"+res.getInt("cod_especificacion")+"' " +
                           " left outer join tipo_resultado_descriptivo t on t.cod_tipo_resultado_descriptivo = r.cod_tipo_resultado_descriptivo " +
                           " where p.COD_PROGRAMA_PROD_CONTROL_CALIDAD = '"+codProgramaControlCalidad+"' and r.cod_tipo_resultado_estabilidad = 1 ";
                   
                   consulta = " select isnull(t.NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,'') NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,r.resultado_numerico from resultado_fisico_estabilidad r" +
                           " left outer join TIPO_RESULTADO_DESCRIPTIVO t on t.COD_TIPO_RESULTADO_DESCRIPTIVO = r.COD_TIPO_RESULTADO_DESCRIPTIVO" +
                           " where r.cod_programa_prod_control_calidad = '"+codProgramaControlCalidad+"' " +
                           " and r.cod_especificacion = '"+res.getInt("cod_especificacion")+"' and r.cod_tipo_resultado_estabilidad = 1" +
                           " order by r.cod_control_calidad_analisis ";
                   System.out.println("consulta zzzzzzzzz "  + consulta);
                   rs1 = st1.executeQuery(consulta);
                   while(rs1.next()){
                       out.print("<td class='celdaLocal'>"+rs1.getString("nombre_tipo_resultado_descriptivo")+" "+rs1.getDouble("resultado_numerico")+"</td>");
                   }
                   out.print("</tr>");
              }
                   //listado vertical
                   consulta = " select m.NOMBRE_MATERIAL,e.LIMITE_INFERIOR,e.LIMITE_SUPERIOR,e.DESCRIPCION,(select count(*) from programa_produccion_control_calidad_analisis where cod_programa_prod_control_calidad = '"+codProgramaControlCalidad+"' ) registros " +
                           " from ESPECIFICACIONES_QUIMICAS_PRODUCTO e" +
                           " inner join ESPECIFICACIONES_QUIMICAS_CC e1 on e1.COD_ESPECIFICACION = e.COD_ESPECIFICACION" +
                           " inner join materiales m on m.COD_MATERIAL = e.COD_MATERIAL" +
                           " where e.COD_PRODUCTO = '"+codProducto+"' and e.ESTADO = 1 and e.cod_especificacion=2 ";
                   out.print("<table width='80%' align='center'   style='border-top:solid #000000 1px;border-left:solid #000000 1px;margin-top:12px' class='outputText2' cellspacing='0'>");

                   
                   Statement st_1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                   ResultSet rs_1 = st_1.executeQuery(consulta);

                   
                   if(rs_1.next()){
                       out.print("<tr><td class='celdaLocal'  colspan='"+rs_1.getInt("registros")+2+"'><center><b>FISICOQUIMICOS: CUANTIFICACION DEL/LOS PRINCIPIO(S) ACTIVO(S)</b></center></td></tr>");
                   
                       out.print("<tr><td class='celdaLocal' style='width:20%'><b>PRINCIPIO ACTIVO</b></td><td class='celdaLocal' style='width:20%'><b>ESPECIFICACION</b></td>");
                       for(int i=1;i<=rs_1.getInt("registros");i++){
                            out.print("<td class='celdaLocal' style='width:15%'><b>mes "+i+"</b></td>");
                       }
                       out.print("</tr>");
                   }
                   
                   rs_1.beforeFirst();

                   while(rs_1.next()){
                       out.print("<tr><td class='celdaLocal'><b>"+rs_1.getString("nombre_material")+"</b></td><td class='celdaLocal'><b>"+((rs_1.getDouble("limite_inferior")>0&&rs_1.getDouble("limite_superior")>0)?rs_1.getDouble("limite_inferior")+"% - "+rs_1.getDouble("limite_superior")+"% ":rs_1.getString("descripcion"))+"</b></td>");
                       consulta = " select m.cod_material,       m.nombre_material,       eqp.COD_ESPECIFICACION,       m.NOMBRE_MATERIAL,       eqp.LIMITE_INFERIOR," +
                           "     eqp.LIMITE_SUPERIOR, eqp.DESCRIPCION, r.resultado_numerico,isnull(t.nombre_tipo_resultado_descriptivo,'') nombre_tipo_resultado_descriptivo,r.cod_tipo_resultado," +
                           "     r.COD_TIPO_RESULTADO_DESCRIPTIVO, r.resultado_numerico" +
                           "     from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp" +
                           "     inner join materiales m on m.COD_MATERIAL = eqp.COD_MATERIAL" +
                           "     left outer join resultado_quimico_estabilidad r on r.cod_especificacion = eqp.COD_ESPECIFICACION" +
                           "     and r.cod_programa_prod_control_calidad = '"+codProgramaControlCalidad+"'" +
                           "     left outer join tipo_resultado_descriptivo t on t.cod_tipo_resultado_descriptivo = r.cod_tipo_resultado_descriptivo " +
                           //"   and r.cod_control_calidad_analisis = '"+rs4.getInt("cod_control_calidad_analisis")+"'" +
                           "     where eqp.COD_PRODUCTO = '"+codProducto+"' and" +
                           "     eqp.ESTADO = 1 and r.cod_tipo_resultado_estabilidad = 1 and eqp.cod_especificacion=2 ";
                            System.out.println("consulta " + consulta);
                            Statement st5 = con.createStatement();
                            ResultSet rs5 = st5.executeQuery(consulta);
                            while(rs5.next()){
                                out.print("<td class='celdaLocal'>"+rs5.getString("nombre_tipo_resultado_descriptivo")+" "+ rs5.getDouble("resultado_numerico")+" </td> ");
                                
                            }
                            out.print("</tr>");
                            
                   }

                   
                   out.print("</table>");
                   
               
               }catch(Exception e){
                   e.printStackTrace();
               }
            %>

               <%-- resultados en condiciones de estabilidad --%>

<%
            try
            {
               Connection con=null;
               con=Util.openConnection(con);
               SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
               //SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");

               String consulta = " select p.FECHA_ANALISIS from PROGRAMA_PRODUCCION_CONTROL_CALIDAD_ANALISIS p where p.COD_PROGRAMA_PROD_CONTROL_CALIDAD = '"+codProgramaControlCalidad+"' ";
               Statement st_2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
               ResultSet rs_2 = st_2.executeQuery(consulta);
               out.print("<table align='center' width='80%'    style='border-top:solid #000000 1px;border-left:solid #000000 1px;margin-top:12px;' class='outputText2' cellspacing='0'>");
               rs_2.last();
               out.print("<tr><td class='celdaLocal'><b>TIEMPO DE MUESTREO</b></td>");
               for(int j =1;j<=rs_2.getRow();j++ ){
                   out.print("<td class='celdaLocal'><b>mes  "+j+"</b></td>");
               }
               out.print("</tr><tr><td class='celdaLocal'><b>FECHA DE ANALISIS</b></td>");
               rs_2.beforeFirst();
               while(rs_2.next()){
                   out.print("<td class='celdaLocal'>"+sdf.format(rs_2.getDate("fecha_analisis"))+"</td>");
               }
               out.print("</tr></table>");


               out.print("<table  align='center' width='80%'    style='border-top:solid #000000 1px;border-left:solid #000000 1px;margin-top:12px;' class='outputText2' cellspacing='0'   >");




               Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
               consulta="select f1.COD_ESPECIFICACION,f1.NOMBRE_ESPECIFICACION,f.LIMITE_INFERIOR,f.LIMITE_SUPERIOR,f.DESCRIPCION,f1.COD_TIPO_RESULTADO_ANALISIS,(select count(*) from PROGRAMA_PRODUCCION_CONTROL_CALIDAD_ANALISIS a where a.COD_PROGRAMA_PROD_CONTROL_CALIDAD = '"+codProgramaControlCalidad+"' ) det_control_calidad" +
                        " from ESPECIFICACIONES_FISICAS_PRODUCTO f" +
                        " inner join ESPECIFICACIONES_FISICAS_CC f1 on f.COD_ESPECIFICACION = f1.COD_ESPECIFICACION" +
                        " where f.COD_PRODUCTO = '"+codProducto+"' and f.ESTADO = 1";
               System.out.println("consulta cargar cabecera "+consulta);
               ResultSet res=st.executeQuery(consulta);
               if(res.next()){
                   %>
                   <tr><td colspan="<%=res.getInt("det_control_calidad")+2%>" class='celdaLocal'><center><b>RESULTADOS DE ESTUDIO DE ESTABILIDAD EST</b></center></td></tr>
                   <%
               }
               %>
               <tr><td  class='celdaLocal' style="width:20%"><center><b>FISICO</b></center></td><td class='celdaLocal' style="width:20%"><center><b>ESPECIFICACION</b></center></td>
               <%
               //para la primera fila
               res.beforeFirst();
               int cont = 1;
               if(res.next()){
                   consulta = " select p.FECHA_ANALISIS,r.COD_TIPO_RESULTADO_DESCRIPTIVO,isnull(t.nombre_tipo_resultado_descriptivo,'') nombre_tipo_resultado_descriptivo,r.resultado_numerico" +
                            " from PROGRAMA_PRODUCCION_CONTROL_CALIDAD_ANALISIS p" +
                           " left outer join resultado_fisico_estabilidad r on r.cod_programa_prod_control_calidad = p.COD_PROGRAMA_PROD_CONTROL_CALIDAD" +
                           " and r.cod_control_calidad_analisis = '"+codProgramaControlCalidadAnalisis+"' and r.cod_especificacion = '"+res.getInt("cod_especificacion")+"'" +
                           " left outer join tipo_resultado_descriptivo t on t.cod_tipo_resultado_descriptivo = r.cod_tipo_resultado_descriptivo " +
                           " where p.COD_PROGRAMA_PROD_CONTROL_CALIDAD = '"+codProgramaControlCalidad+"' and r.cod_tipo_resultado_estabilidad = 2 ";
                   Statement st2 = con.createStatement();
                   ResultSet rs2 = st2.executeQuery(consulta);
                   while(rs2.next()){
                       out.print("<td class='celdaLocal' width='15%'><center><b>mes "+cont+"</b></center></td>");
                       cont++;
                   }
               }
               out.print("</tr>");
               res.beforeFirst();




               Statement st1 = con.createStatement();
               ResultSet rs1 = null;
               while(res.next())
               {
                   out.print("<tr><td class='celdaLocal'><b>"+res.getString("nombre_especificacion")+"</b></td>");
                   out.print("<td class='celdaLocal'><b>&nbsp;"+((res.getDouble("limite_inferior")==0 && res.getDouble("limite_superior")==0)?res.getString("descripcion"):res.getDouble("limite_inferior")+" - "+ res.getDouble("limite_superior"))+"</b></td>");
                   consulta = " select p.FECHA_ANALISIS,r.COD_TIPO_RESULTADO_DESCRIPTIVO,r.resultado_numerico from PROGRAMA_PRODUCCION_CONTROL_CALIDAD_ANALISIS p" +
                           "left outer join resultado_fisico_estabilidad r on r.cod_programa_prod_control_calidad = p.COD_PROGRAMA_PROD_CONTROL_CALIDAD" +
                           "and r.cod_control_calidad_analisis = '' and r.cod_especificacion = ''" +
                           "where p.COD_PROGRAMA_PROD_CONTROL_CALIDAD = 2 ";
                   consulta = " select p.FECHA_ANALISIS,r.COD_TIPO_RESULTADO_DESCRIPTIVO,isnull(t.nombre_tipo_resultado_descriptivo,'') nombre_tipo_resultado_descriptivo,r.resultado_numerico" +
                            " from PROGRAMA_PRODUCCION_CONTROL_CALIDAD_ANALISIS p" +
                           " left outer join resultado_fisico_estabilidad r on r.cod_programa_prod_control_calidad = p.COD_PROGRAMA_PROD_CONTROL_CALIDAD and r.cod_control_calidad_analisis = p.cod_control_calidad_analisis" +
                           " and r.cod_control_calidad_analisis = '"+codProgramaControlCalidadAnalisis+"' and r.cod_especificacion = '"+res.getInt("cod_especificacion")+"' " +
                           " left outer join tipo_resultado_descriptivo t on t.cod_tipo_resultado_descriptivo = r.cod_tipo_resultado_descriptivo " +
                           " where p.COD_PROGRAMA_PROD_CONTROL_CALIDAD = '"+codProgramaControlCalidad+"' and r.cod_tipo_resultado_estabilidad = 2 ";
                   consulta = " select isnull(t.NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,'') NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,r.resultado_numerico from resultado_fisico_estabilidad r" +
                           " left outer join TIPO_RESULTADO_DESCRIPTIVO t on t.COD_TIPO_RESULTADO_DESCRIPTIVO = r.COD_TIPO_RESULTADO_DESCRIPTIVO" +
                           " where r.cod_programa_prod_control_calidad = '"+codProgramaControlCalidad+"' " +
                           " and r.cod_especificacion = '"+res.getInt("cod_especificacion")+"' and r.cod_tipo_resultado_estabilidad = 2" +
                           " order by r.cod_control_calidad_analisis ";
                   System.out.println("consulta "  + consulta);
                   rs1 = st1.executeQuery(consulta);
                   while(rs1.next()){
                       out.print("<td class='celdaLocal'>"+rs1.getString("nombre_tipo_resultado_descriptivo")+" "+rs1.getDouble("resultado_numerico")+"</td>");
                   }
                   out.print("</tr>");
              }
                   //listado vertical
                   consulta = " select m.cod_material,e1.cod_especificacion,e1.nombre_especificacion,m.NOMBRE_MATERIAL,e.LIMITE_INFERIOR,e.LIMITE_SUPERIOR,e.DESCRIPCION,(select count(*) from programa_produccion_control_calidad_analisis where cod_programa_prod_control_calidad = '"+codProgramaControlCalidad+"' ) registros " +
                           " from ESPECIFICACIONES_QUIMICAS_PRODUCTO e" +
                           " inner join ESPECIFICACIONES_QUIMICAS_CC e1 on e1.COD_ESPECIFICACION = e.COD_ESPECIFICACION" +
                           " inner join materiales m on m.COD_MATERIAL = e.COD_MATERIAL" +
                           " where e.COD_PRODUCTO = '"+codProducto+"' and e.ESTADO = 1 and e.cod_especificacion=2 ";
                   out.print("<table width='80%' align='center'   style='border-top:solid #000000 1px;border-left:solid #000000 1px;margin-top:12px' class='outputText2' cellspacing='0'>");

                   
                   Statement st_1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                   
                   ResultSet rs_1 = st_1.executeQuery(consulta);


                   if(rs_1.next()){
                       out.print("<tr><td class='celdaLocal'  colspan='"+rs_1.getInt("registros")+2+"'><center><b>FISICOQUIMICOS: CUANTIFICACION DEL/LOS PRINCIPIO(S) ACTIVO(S)</b></center></td></tr>");

                       out.print("<tr><td class='celdaLocal' style='width:20%'><b>PRINCIPIO ACTIVO</b></td><td class='celdaLocal' style='width:20%'><b>ESPECIFICACION</b></td>");
                       for(int i=1;i<=rs_1.getInt("registros");i++){
                            out.print("<td class='celdaLocal'><b>mes "+i+"</b></td>");
                       }
                       out.print("</tr>");
                   }

                   rs_1.beforeFirst();

                   while(rs_1.next()){
                       out.print("<tr><td class='celdaLocal' ><b>"+rs_1.getString("nombre_material")+"</b></td><td class='celdaLocal'><b>"+((rs_1.getDouble("limite_inferior")>0&&rs_1.getDouble("limite_superior")>0)?rs_1.getDouble("limite_inferior")+"% - "+rs_1.getDouble("limite_superior")+"% ":rs_1.getString("descripcion"))+"</b></td>");
                       consulta = " select m.cod_material,       m.nombre_material,       eqp.COD_ESPECIFICACION,       m.NOMBRE_MATERIAL,       eqp.LIMITE_INFERIOR," +
                           "     eqp.LIMITE_SUPERIOR, eqp.DESCRIPCION, r.resultado_numerico,isnull(t.nombre_tipo_resultado_descriptivo,'') nombre_tipo_resultado_descriptivo,r.cod_tipo_resultado," +
                           "     r.COD_TIPO_RESULTADO_DESCRIPTIVO, r.resultado_numerico" +
                           "     from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp" +
                           "     inner join materiales m on m.COD_MATERIAL = eqp.COD_MATERIAL" +
                           "     left outer join resultado_quimico_estabilidad r on r.cod_especificacion = eqp.COD_ESPECIFICACION" +
                           "     and r.cod_programa_prod_control_calidad = '"+codProgramaControlCalidad+"'" +
                           "     left outer join tipo_resultado_descriptivo t on t.cod_tipo_resultado_descriptivo = r.cod_tipo_resultado_descriptivo " +
                           //"   and r.cod_control_calidad_analisis = '"+rs4.getInt("cod_control_calidad_analisis")+"'" +
                           "     where eqp.COD_PRODUCTO = '"+codProducto+"' and" +
                           "     eqp.ESTADO = 1 and r.cod_tipo_resultado_estabilidad = 2 and r.cod_material = eqp.cod_material and eqp.cod_material = '"+rs_1.getString("cod_material")+"'  and eqp.cod_especificacion = '"+rs_1.getInt("cod_especificacion")+"' and eqp.cod_especificacion=2  ";
                            System.out.println(" consulta zxzx   " + consulta);
                            Statement st5 = con.createStatement();
                            ResultSet rs5 = st5.executeQuery(consulta);
                            while(rs5.next()){
                                out.print("<td class='celdaLocal'>"+rs5.getString("nombre_tipo_resultado_descriptivo")+" "+ rs5.getDouble("resultado_numerico")+" </td> ");
                            }
                            out.print("</tr>");
                   }


                   out.print("</table>");


               }catch(Exception e){
                   e.printStackTrace();
               }
            %>
           
            </table>

            
        </form>
    </body>
</html>
