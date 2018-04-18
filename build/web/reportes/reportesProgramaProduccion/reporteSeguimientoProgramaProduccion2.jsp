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
<%@ page import = "java.util.Locale"%>
<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>


<%! Connection con = null;
String codPresentacion = "";
String nombrePresentacion = "";
String linea_mkt = "";
String agenciaVenta = "";
%>
<%! public String nombrePresentacion1() {



    String nombreproducto = "";
//ManagedAccesoSistema bean1=(ManagedAccesoSistema)com.cofar.util.Util.getSessionBean("ManagedAccesoSistema");
    try {
        con = Util.openConnection(con);
        String sql_aux = "select cod_presentacion, nombre_producto_presentacion from presentaciones_producto where cod_presentacion='" + codPresentacion + "'";
        System.out.println("PresentacionesProducto:sql:" + sql_aux);
        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rs = st.executeQuery(sql_aux);
        while (rs.next()) {
            String codigo = rs.getString(1);
            nombreproducto = rs.getString(2);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return nombreproducto;
}

public String showHora(String horaRecibe) {
String aux=horaRecibe;
                    double a = Double.parseDouble(aux.equals("")?"0":aux);
                    double auxa=a;
                    System.out.println("horas HOMBRE EVALUAR = "+a);
                    double cont=1;
                    double resta=300;//resta=300  es un numero para que ingrese al while, luego cambia su valor
                    if(a>=1)
                        {
                            while(resta>1)
                                {   resta=a-cont;
                                    cont++;
                                   System.out.println("cont"+cont);
                                    System.out.println("ahora es "+resta);
                                }

                        }
                      a=(resta*100)*0.6;
                      if(a==60){a=0;}

                      if(a>0 || auxa<=1)
                          {
                           System.out.println("MULTIPLICAMOS DIRECTAMENTE");
                           cont--;
                           System.out.println("AHORA A "+a);
                      }
                      if(auxa>0.0 && auxa<1)
                          {
                          auxa=(auxa*100)*0.6;
                           System.out.println("ENTRA A UN IF ESPECIAL"+auxa);
                           a=auxa;
                          }
                      //double min=a;
                      int min = (int)a;
                      if(min>=60){min=0;}
                      //double hora=cont;

                      int hora = (int) cont;

                     //String concatena=" ("+hora+"h:"+min+"min)";
                     String concatena=hora+"h:"+min+"min";
                   // System.out.println("EN HORAS Y MINUTOS ES"+concatena);
return concatena;
}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
    </head>
    <body>
        <form>
            <h4 align="center">Reporte Seguimiento Programa Producción</h4>

                    <%
                    try {

                /*
                         <input type="hidden" name="codProgramaProduccionPeriodo">
                        <input type="hidden" name="codCompProd">
                        <input type="hidden" name="nombreCompProd">
                        */

                        NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat formato = (DecimalFormat) numeroformato;
                        formato.applyPattern("#,###.##;(#,###.##)");

                        SimpleDateFormat f=new SimpleDateFormat("dd/MM/yyyy");

                        con = Util.openConnection(con);




                        String codProgramaProdPeriodo=request.getParameter("codProgramaProduccionPeriodo")==null?"''":request.getParameter("codProgramaProduccionPeriodo");
                        String arrayCodCompProd = request.getParameter("codCompProdArray")==null?"''":request.getParameter("codCompProdArray");
                        String nombreProgramaProduccionPeriodo = request.getParameter("nombreProgramaProduccionPeriodo")==null?"''":request.getParameter("nombreProgramaProduccionPeriodo");
                        arrayCodCompProd = arrayCodCompProd + (arrayCodCompProd.length()==0?"' '":"");

                        System.out.println("los datos de peticion para el reporte : "+request.getParameter("codAreaEmpresaP"));
                        System.out.println(request.getParameter("nombreAreaEmpresaP"));

                        System.out.println(request.getParameter("desdeFechaP"));
                        System.out.println(request.getParameter("hastaFechaP"));

                        String arrayCodAreaEmpresa= request.getParameter("codAreaEmpresaP");
                        String arrayNombreAreaEmpresa= request.getParameter("nombreAreaEmpresaP");

                        String desdeFecha=request.getParameter("desdeFechaP");
                        String hastaFecha=request.getParameter("hastaFechaP");

                        String codEstadoProgramaProduccion=request.getParameter("codEstadoPrograma");
                         String arraydesde[]=desdeFecha.split("/");
                         desdeFecha=arraydesde[2] +"/"+ arraydesde[1]+"/"+arraydesde[0];

                         String arrayhasta[]=hastaFecha.split("/");
                         hastaFecha=arrayhasta[2]+"/"+arrayhasta[1]+"/"+arrayhasta[0];

                         //Double totalHoraInicio=0.0d;
                         //Double totalHoraFinal=0.0d;

                         Double totalHorasHombre=0.0d;
                         Double totalHorasMaquina=0.0d;

                         Double totalEstandarHombre=0.0d;
                         Double totalEstandarMaquina=0.0d;
                         //1:todos , 2:con seguimiento, 3:sin seguimiento


                         String codTipoReporteSeguimientoProgramaProduccion=request.getParameter("codTipoReporteSeguimientoProgramaProduccion");


                         //System.out.println("las fechas en el reporte" + desdeFecha + " " +hastaFecha );


                   %>

            <div class="outputText0" align="center">
                PROGRAMA PRODUCCION: <%= nombreProgramaProduccionPeriodo %> <br>
                AREA(S) : <%= arrayNombreAreaEmpresa %><br>
                DE <%= arraydesde[0] +"/"+ arraydesde[1]+"/"+arraydesde[2] %> <br>
                HASTA <%= arrayhasta[0] +"/"+ arrayhasta[1]+"/"+arrayhasta[2] %>
            </div>

            <br>
            <table width="80%" align="center" class="outputText0" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >


                <tr class="">
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='45%' align="center" colspan="2"><b>Producto - Actividades</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center" ><b>Lote</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Maquina</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Fecha Inicial</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>fecha Final</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Hombre</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Tiempo Horas Hombre</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Maquina</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Tiempo Horas Maquina</b></td>
                 <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Hombre Estandar</b></td>
                 <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Tiempo Hombre Estandar</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Maquina Estandar</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Tiempo Maquina Estandar</b></td></tr>

                <%

                String consulta=" SELECT  PPR.COD_LOTE_PRODUCCION,CPR.COD_COMPPROD ,CPR.nombre_prod_semiterminado " +
                                " FROM PROGRAMA_PRODUCCION PPR INNER JOIN COMPONENTES_PROD CPR ON PPR.COD_COMPPROD = CPR.COD_COMPPROD " +
                                " WHERE PPR.COD_ESTADO_PROGRAMA IN ("+codEstadoProgramaProduccion+") AND PPR.COD_PROGRAMA_PROD='"+codProgramaProdPeriodo+ "'" +
                                " AND PPR.COD_LOTE_PRODUCCION +''+ CAST(PPR.COD_COMPPROD  AS VARCHAR(20)) IN ("+arrayCodCompProd+")" +
                                " AND CPR.COD_AREA_EMPRESA IN ("+arrayCodAreaEmpresa+") " +
                                " ORDER BY CPR.nombre_prod_semiterminado,PPR.COD_LOTE_PRODUCCION ";

                System.out.println("consulta 1 "+ consulta);
                con=Util.openConnection(con);
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs = st.executeQuery(consulta);
                while (rs.next()) {
                    //System.out.println("consulta 1 "+ consulta);
                    String nombreProductoSemiternimando= rs.getString("nombre_prod_semiterminado");
                    String codLoteProduccion = rs.getString("COD_LOTE_PRODUCCION");
                    String codCompProd = rs.getString("COD_COMPPROD");
                %>
                <tr>
                    <td class="border"  align="left" colspan="2"><b><%=nombreProductoSemiternimando%></b></td>
                    <td class="border" align="center"><b><%=codLoteProduccion%></b></td>
                    <td class="border" align="right" colspan="6">&nbsp;</td>
                </tr>
                                <%
                             String consultaActividades="";
                            if(codTipoReporteSeguimientoProgramaProduccion.equals("1")){
                            consultaActividades="SELECT PPR.COD_LOTE_PRODUCCION,CPR.nombre_prod_semiterminado,APR.COD_ACTIVIDAD,AFM.COD_ACTIVIDAD_FORMULA, APR.NOMBRE_ACTIVIDAD,AFM.ORDEN_ACTIVIDAD,FM.COD_FORMULA_MAESTRA " +
                                        " FROM ACTIVIDADES_FORMULA_MAESTRA AFM  " +
                                        " INNER JOIN ACTIVIDADES_PRODUCCION APR ON AFM.COD_ACTIVIDAD = APR.COD_ACTIVIDAD  " +
                                        " INNER JOIN FORMULA_MAESTRA FM ON FM.COD_FORMULA_MAESTRA = AFM.COD_FORMULA_MAESTRA  "+
                                        " INNER JOIN PROGRAMA_PRODUCCION PPR ON PPR.COD_FORMULA_MAESTRA = FM.COD_FORMULA_MAESTRA " +
                                        " INNER JOIN COMPONENTES_PROD CPR ON PPR.COD_COMPPROD = CPR.COD_COMPPROD " +
                                        " AND CPR.COD_COMPPROD = FM.COD_COMPPROD " +
                                        " WHERE PPR.COD_COMPPROD='"+codCompProd+"'" +
                                        " AND PPR.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"' " +
                                        " AND PPR.COD_ESTADO_PROGRAMA IN ("+codEstadoProgramaProduccion+") AND PPR.COD_PROGRAMA_PROD='"+codProgramaProdPeriodo+"'" +
                                        " ORDER BY CPR.nombre_prod_semiterminado,PPR.COD_LOTE_PRODUCCION,AFM.ORDEN_ACTIVIDAD";
                            }
                             if(codTipoReporteSeguimientoProgramaProduccion.equals("2")){
                            consultaActividades="SELECT PPR.COD_LOTE_PRODUCCION,CPR.nombre_prod_semiterminado,APR.COD_ACTIVIDAD,AFM.COD_ACTIVIDAD_FORMULA, APR.NOMBRE_ACTIVIDAD,AFM.ORDEN_ACTIVIDAD,FM.COD_FORMULA_MAESTRA " +
                                        " FROM ACTIVIDADES_FORMULA_MAESTRA AFM " +
                                        " INNER JOIN ACTIVIDADES_PRODUCCION APR ON AFM.COD_ACTIVIDAD = APR.COD_ACTIVIDAD  " +
                                        " INNER JOIN FORMULA_MAESTRA FM ON FM.COD_FORMULA_MAESTRA = AFM.COD_FORMULA_MAESTRA  "+
                                        " INNER JOIN PROGRAMA_PRODUCCION PPR ON PPR.COD_FORMULA_MAESTRA = FM.COD_FORMULA_MAESTRA " +
                                        " INNER JOIN COMPONENTES_PROD CPR ON PPR.COD_COMPPROD = CPR.COD_COMPPROD " +
                                        " AND CPR.COD_COMPPROD = FM.COD_COMPPROD " +
                                        " WHERE PPR.COD_COMPPROD='"+codCompProd+"'" +
                                        " AND PPR.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"' " +
                                        " AND PPR.COD_ESTADO_PROGRAMA IN ("+codEstadoProgramaProduccion+") AND PPR.COD_PROGRAMA_PROD='"+codProgramaProdPeriodo+"'" +
                                        " AND AFM.COD_ACTIVIDAD_FORMULA IN (select s.COD_ACTIVIDAD_PROGRAMA   " +
                                        " from SEGUIMIENTO_PROGRAMA_PRODUCCION s   " +
                                        " where  s.COD_PROGRAMA_PROD='"+codProgramaProdPeriodo+"' and s.COD_COMPPROD='"+codCompProd+"' and s.COD_FORMULA_MAESTRA=FM.COD_FORMULA_MAESTRA and s.COD_LOTE_PRODUCCION=PPR.COD_LOTE_PRODUCCION " +
                                        " and s.FECHA_INICIO>='"+ desdeFecha +" 00:00:00' and  s.FECHA_FINAL<= '"+hastaFecha+" 23:59:59')  " +
                                        " ORDER BY CPR.nombre_prod_semiterminado,PPR.COD_LOTE_PRODUCCION,AFM.ORDEN_ACTIVIDAD";
                                        }
                             if(codTipoReporteSeguimientoProgramaProduccion.equals("3")){
                                 consultaActividades="SELECT PPR.COD_LOTE_PRODUCCION,CPR.nombre_prod_semiterminado,APR.COD_ACTIVIDAD,AFM.COD_ACTIVIDAD_FORMULA, APR.NOMBRE_ACTIVIDAD,AFM.ORDEN_ACTIVIDAD,FM.COD_FORMULA_MAESTRA " +
                                        " FROM ACTIVIDADES_FORMULA_MAESTRA AFM " +
                                        " INNER JOIN ACTIVIDADES_PRODUCCION APR ON AFM.COD_ACTIVIDAD = APR.COD_ACTIVIDAD  " +
                                        " INNER JOIN FORMULA_MAESTRA FM ON FM.COD_FORMULA_MAESTRA = AFM.COD_FORMULA_MAESTRA  "+
                                        " INNER JOIN PROGRAMA_PRODUCCION PPR ON PPR.COD_FORMULA_MAESTRA = FM.COD_FORMULA_MAESTRA " +
                                        " INNER JOIN COMPONENTES_PROD CPR ON PPR.COD_COMPPROD = CPR.COD_COMPPROD " +
                                        " AND CPR.COD_COMPPROD = FM.COD_COMPPROD " +
                                        " WHERE PPR.COD_COMPPROD='"+codCompProd+"'" +
                                        " AND PPR.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"' " +
                                        " AND PPR.COD_ESTADO_PROGRAMA IN ("+codEstadoProgramaProduccion+") AND PPR.COD_PROGRAMA_PROD='"+codProgramaProdPeriodo+"'" +
                                        " AND AFM.COD_ACTIVIDAD_FORMULA NOT IN (select s.COD_ACTIVIDAD_PROGRAMA   " +
                                        " from SEGUIMIENTO_PROGRAMA_PRODUCCION s   " +
                                        " where  s.COD_PROGRAMA_PROD='"+codProgramaProdPeriodo+"' and s.COD_COMPPROD='"+codCompProd+"' and s.COD_FORMULA_MAESTRA=FM.COD_FORMULA_MAESTRA and s.COD_LOTE_PRODUCCION=PPR.COD_LOTE_PRODUCCION " +
                                        " and s.FECHA_INICIO>='"+ desdeFecha +" 00:00:00' and  s.FECHA_FINAL<= '"+hastaFecha+" 23:59:59')  " +
                                        " ORDER BY CPR.nombre_prod_semiterminado,PPR.COD_LOTE_PRODUCCION,AFM.ORDEN_ACTIVIDAD";
                             }

                                    //setCon(Util.openConnection(getCon()));
                            System.out.println("consulta 2 "+ consultaActividades);


                            Statement stActividad=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet rsActividad=stActividad.executeQuery(consultaActividades);
                            float horasHombre = 0;
                            float horasMaquina = 0;

                            float horasEstandarHombre = 0;
                            float horasEstandarMaquina = 0;

                            while(rsActividad.next()){
                                String codActividad = rsActividad.getString("COD_ACTIVIDAD");
                                String nombreActividad = rsActividad.getString("NOMBRE_ACTIVIDAD");
                                String codFormulaMaestra = rsActividad.getString("COD_FORMULA_MAESTRA");
                                String codActividadFormula= rsActividad.getString("COD_ACTIVIDAD_FORMULA");
                                String ordenActividad = rsActividad.getString("ORDEN_ACTIVIDAD");

                            %>
                                <tr>
                                <td align="right"  style="border : solid #f2f2f2 1px" width="5%" ><%=ordenActividad%></td>
                                <td align="left"  style="border : solid #f2f2f2 1px" width="40%" colspan="2"><%=nombreActividad%></td>
                                    <%


    String  consultaSeguimiento = " select s.COD_SEGUIMIENTO_PROGRAMA,s.HORAS_HOMBRE,s.HORAS_MAQUINA,s.FECHA_INICIO,s.FECHA_FINAL, " +
                                    " s.HORA_INICIO,s.HORA_FINAL,(select isnull(M.COD_MAQUINA,'') from MAQUINARIAS M where s.COD_MAQUINA=M.COD_MAQUINA ) COD_MAQUINA, " +
                                    " (select isnull(M.NOMBRE_MAQUINA,'') from MAQUINARIAS M where s.COD_MAQUINA=M.COD_MAQUINA ) NOMBRE_MAQUINA " +
                                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION s  where s.COD_ACTIVIDAD_PROGRAMA='"+codActividadFormula+"'  " +
                                    " and s.COD_PROGRAMA_PROD='"+codProgramaProdPeriodo+"'  and s.COD_COMPPROD='"+codCompProd+"' and s.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'  " +
                                    " and s.COD_LOTE_PRODUCCION='"+codLoteProduccion+"' and s.FECHA_INICIO>='"+ desdeFecha +" 00:00:00'  and  s.FECHA_FINAL<= '"+hastaFecha+" 23:59:59'" +
                                    " order by s.COD_SEGUIMIENTO_PROGRAMA desc ";

                            System.out.println("consulta 3 " + consultaSeguimiento);

                                    //setCon(Util.openConnection(getCon()));


                            Statement stSeguimiento=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet rsSeguimiento=stSeguimiento.executeQuery(consultaSeguimiento);



                            if(rsSeguimiento.next()){

                                Date fechaInicioSeguimiento = rsSeguimiento.getDate("FECHA_INICIO");
                                Date fechaFinalSeguimiento = rsSeguimiento.getDate("FECHA_FINAL");
                                String horaInicio = rsSeguimiento.getString("HORA_INICIO");
                                String horaFinal = rsSeguimiento.getString("HORA_FINAL");
                                String horaHombre = rsSeguimiento.getString("HORAS_HOMBRE");
                                String horaMaquina = rsSeguimiento.getString("HORAS_MAQUINA");
                                String nombreMaquina = rsSeguimiento.getString("NOMBRE_MAQUINA");
                                String codMaquina = rsSeguimiento.getString("COD_MAQUINA");

                                String horasHombreEstandar = "";
                                String horasMaquinaEstandar = "";
                                
                             if(horaHombre!=null)
                                 {
                                 String horasEstandar="";
                                 if(codMaquina!=null)
                                     {                                       
                                horasEstandar="select maf.HORAS_HOMBRE,isnull(maf.HORAS_MAQUINA,0)HORAS_MAQUINA from MAQUINARIA_ACTIVIDADES_FORMULA maf, SEGUIMIENTO_PROGRAMA_PRODUCCION s," +
                            " ACTIVIDADES_FORMULA_MAESTRA afm where maf.COD_ACTIVIDAD_FORMULA=afm.COD_ACTIVIDAD_FORMULA and s.COD_FORMULA_MAESTRA=afm.COD_FORMULA_MAESTRA" +
                            " and maf.COD_MAQUINA='"+codMaquina+"' and maf.COD_ACTIVIDAD_FORMULA='"+codActividadFormula+"' group by maf.HORAS_HOMBRE,maf.HORAS_MAQUINA";
                                    }
                                 else
                                     {
                                     System.out.println("COD MAQUINA ES NULL");
                                horasEstandar="select maf.HORAS_HOMBRE,isnull(maf.HORAS_MAQUINA,0)HORAS_MAQUINA from MAQUINARIA_ACTIVIDADES_FORMULA maf, SEGUIMIENTO_PROGRAMA_PRODUCCION s," +
                            " ACTIVIDADES_FORMULA_MAESTRA afm where maf.COD_ACTIVIDAD_FORMULA=afm.COD_ACTIVIDAD_FORMULA and s.COD_FORMULA_MAESTRA=afm.COD_FORMULA_MAESTRA" +
                            " and maf.COD_ACTIVIDAD_FORMULA='"+codActividadFormula+"' group by maf.HORAS_HOMBRE,maf.HORAS_MAQUINA";
                                 }
                            System.out.println("HORAS ESTANDAR " + horasEstandar);


                            Statement stEstandar=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet rsEstandar=stEstandar.executeQuery(horasEstandar);
                                
                                     if(rsEstandar.next()){
                                     horasHombreEstandar = rsEstandar.getString("HORAS_HOMBRE");
                                        
                                         horasMaquinaEstandar = rsEstandar.getString("HORAS_MAQUINA");
                                   
                                         System.out.println("horas hombreEstandar " + horasHombreEstandar);
                                       
                                         System.out.println("horas maquinaEstandar " + horasMaquinaEstandar);
                                             
                                     }
                                }
                                else
                                {
                                    horasHombreEstandar = "0";
                                    horasMaquinaEstandar = "0";
                                }
                        System.out.println("ENVIANDO A LA FUNCION");                        
                                String showHoraHombre=showHora(horaHombre);                        
                                System.out.println("ENVIANDO A LA FUNCION1");
                                String showHoraMaquina=showHora(horaMaquina);
                                System.out.println("ENVIANDO A LA FUNCION2");
                                String showHoraHombreEstandar=showHora(horasHombreEstandar);
                                System.out.println("ENVIANDO A LA FUNCION3");
                                String showHoraMaquinaEstandar=showHora(horasMaquinaEstandar);
                                
                                 //System.out.println("EN HORAS Y MINUTOS ES"+muest);

                                out.print("<td  style='border : solid #f2f2f2 1px'  align='right' width='9.17%' >"+(nombreMaquina==null?"&nbsp;":nombreMaquina)+"</td>");
                                out.print("<td  style='border : solid #f2f2f2 1px'  align='left' width='9.17%'  >"+f.format(fechaInicioSeguimiento)+" </td>");
                                out.print("<td  style='border : solid #f2f2f2 1px'  align='left' width='9.17%' >"+f.format(fechaFinalSeguimiento)+" </td>");
                                out.print("<td  style='border : solid #f2f2f2 1px'  align='right' width='9.17%' >"+(horaHombre==null||horaHombre.equals("")?"&nbsp;":horaHombre)+" </td>");
                                out.print("<td  style='border : solid #f2f2f2 1px'  align='right' width='9.17%' >"+showHoraHombre+" </td>");
                                out.print("<td  style='border : solid #f2f2f2 1px'  align='right' width='9.17%' >"+(horaMaquina==null||horaMaquina.equals("")?"&nbsp;":horaMaquina)+" </td>");
                                out.print("<td  style='border : solid #f2f2f2 1px'  align='right' width='9.17%' >"+showHoraMaquina+" </td>");
                                out.print("<td  style='border : solid #f2f2f2 1px'  align='right' width='9.17%' >"+(horasHombreEstandar==null||horasHombreEstandar.equals("")?"&nbsp;":horasHombreEstandar)+" </td>");
                                out.print("<td  style='border : solid #f2f2f2 1px'  align='right' width='9.17%' >"+showHoraHombreEstandar+" </td>");
                                out.print("<td  style='border : solid #f2f2f2 1px'  align='right' width='9.17%' >"+(horasMaquinaEstandar==null||horasMaquinaEstandar.equals("")?"&nbsp;":horasMaquinaEstandar)+" </td>");
                                out.print("<td  style='border : solid #f2f2f2 1px'  align='right' width='9.17%' >"+showHoraMaquinaEstandar+" </td>");

                                

                                //totalHoraInicio = totalHoraInicio + Double.valueOf(horaInicio.equals("")?"0":horaInicio);
                                //totalHoraFinal = totalHoraFinal + Double.valueOf(horaFinal.equals("")?"0":horaFinal);

                                horasHombre = horasHombre + Float.valueOf(horaHombre.equals("")?"0":horaHombre.replace(",", "."));
                                horasMaquina = horasMaquina + Float.valueOf(horaMaquina.equals("")?"0":horaMaquina.replace(",", "."));

                                totalHorasHombre = totalHorasHombre + Double.valueOf(horaHombre.equals("")?"0":horaHombre.replace(",", "."));
                                totalHorasMaquina = totalHorasMaquina + Double.valueOf(horaMaquina.equals("")?"0":horaMaquina.replace(",", "."));

                                horasEstandarHombre = horasEstandarHombre + Float.valueOf(horasHombreEstandar.equals("")?"0":horasHombreEstandar.replace(",", "."));
                                horasEstandarMaquina = horasEstandarMaquina + Float.valueOf(horasMaquinaEstandar.equals("")?"0":horasMaquinaEstandar.replace(",", "."));

                                totalEstandarHombre = totalEstandarHombre + Double.valueOf(horasHombreEstandar.equals("")?"0":horasHombreEstandar.replace(",", "."));
                                totalEstandarMaquina = totalEstandarMaquina + Double.valueOf(horasMaquinaEstandar.equals("")?"0":horasMaquinaEstandar.replace(",", "."));

                                //totalHorasHombre = totalHorasHombre + Double.valueOf(horaHombre.equals("")?"0":horaHombre.replace(",", "."));
                                //totalHorasMaquina = totalHorasMaquina + Double.valueOf(horaMaquina.equals("")?"0":horaMaquina.replace(",", "."));

                                }
                                out.print("</tr>");
                            }
                                String aux1 = String.valueOf(horasHombre);
                                String tHorasHombre=showHora(aux1);

                                String aux2 = String.valueOf(horasMaquina);
                                String tHorasMaquina=showHora(aux2);

                                
                                String aux5 = String.valueOf(horasEstandarHombre);
                                String tHorasEstandarHombre=showHora(aux5);

                                String aux6 = String.valueOf(horasEstandarMaquina);
                                String tHorasEstandarMaquina=showHora(aux6);

                               

                                
                            out.print("<tr>");
                            out.print("<td align='right'  style='border : solid #D8D8D8 1px' >&nbsp;</td>");
                            out.print("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' >&nbsp;</td>");
                            out.print("<td align='center' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' >TOTAL</td>");
                            out.print("<td align='center' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' >&nbsp;</td>");
                            out.print("<td align='center' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' >&nbsp;</td>");
                            out.print("<td align='center' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' >&nbsp;</td>");
                            out.print("<td align='right' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' >"+formato.format(horasHombre)+"</td>");
                            out.print("<td align='right' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' >"+tHorasHombre+"</td>");
                            out.print("<td align='right' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' >"+formato.format(horasMaquina)+"</td>");
                            out.print("<td align='right' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' >"+tHorasMaquina+"</td>");
                            out.print("<td align='right' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' >"+formato.format(horasEstandarHombre)+"</td>");
                            out.print("<td align='right' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' >"+tHorasEstandarHombre+"</td>");
                            out.print("<td align='right' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' >"+formato.format(horasEstandarMaquina)+"</td>");
                            out.print("<td align='right' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' >"+tHorasEstandarMaquina+"</td>");

                              

                           
                            out.print("</tr>");
                        }
                                String aux3 = String.valueOf(totalHorasHombre);
                                String tTotalHorasHombre=showHora(aux3);

                                String aux4 = String.valueOf(totalHorasMaquina);
                                String tTotalHorasMaquina=showHora(aux4);

                                String aux7 = String.valueOf(totalEstandarHombre);                                
                                String tTotalEstandarHombre=showHora(aux7);

                                String aux8 = String.valueOf(totalEstandarMaquina);
                                String tTotalEstandarMaquina=showHora(aux8);
                                out.print("<tr>");
                                out.print("<td align='right'  style='border : solid #D8D8D8 1px' ></td>");
                                out.print("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' ></td>");
                                out.print("<td align='center' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' >TOTAL GENERAL</td>");
                                out.print("<td align='center' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' ></td>");
                                out.print("<td align='center' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' ></td>");
                                out.print("<td align='center' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' ></td>");
                                out.print("<td align='right' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' >"+formato.format(totalHorasHombre)+"</td>");
                                out.print("<td align='right' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' >"+tTotalHorasHombre+"</td>");
                                out.print("<td align='right' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' >"+formato.format(totalHorasMaquina)+"</td>");
                                out.print("<td align='right' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' >"+tTotalHorasMaquina+"</td>");
                                out.print("<td align='right' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' >"+formato.format(totalEstandarHombre)+"</td>");
                                out.print("<td align='right' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' >"+tTotalEstandarHombre+"</td>");
                                out.print("<td align='right' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' >"+formato.format(totalEstandarMaquina)+"</td>");
                                out.print("<td align='right' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' >"+tTotalEstandarMaquina+"</td>");
                                out.print("</tr>");


               %>
               </table>

                <%



                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                %>
            <br>

            <br>
            <div align="center">
                <%--<INPUT type="button" class="commandButton" name="btn_registrar" value="<-- Atrás" onClick="cancelar();"  >--%>

            </div>
        </form>
    </body>
</html>





