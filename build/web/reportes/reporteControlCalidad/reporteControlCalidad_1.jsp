
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
<%!
private boolean verificarResultadoAprobar(String codTipoResultadoAnalisis,String codTipoResultadoDescriptivo,double resultadoNumerico,double limiteSuperior,double limiteInferior,double valorExacto)
    {
        boolean resultado=true;
        if(codTipoResultadoAnalisis.equals("1"))
        {
            if(codTipoResultadoDescriptivo.equals("2"))
            {   
                return false;
            }
        }
        if(codTipoResultadoAnalisis.equals("2"))
        {
            if((resultadoNumerico>limiteSuperior)||(resultadoNumerico<limiteInferior))
            {
                return false;
            }
        }
        if(codTipoResultadoAnalisis.equals("3"))
        {
            if(resultadoNumerico!=valorExacto)
            {
                return false;
            }
        }
        if(codTipoResultadoAnalisis.equals("4"))
        {
            if(resultadoNumerico<=valorExacto)
            {
                return false;
            }
        }
        if(codTipoResultadoAnalisis.equals("5"))
        {
            if(resultadoNumerico>=valorExacto)
            {
                return false;
            }
        }
        if(codTipoResultadoAnalisis.equals("6"))
        {
            if(resultadoNumerico<valorExacto)
            {
                return false;
            }
        }
        if(codTipoResultadoAnalisis.equals("7"))
        {
            if(resultadoNumerico>valorExacto)
            {
               return false;
            }
        }
        if(codTipoResultadoAnalisis.equals("8"))
        {
            if((resultadoNumerico<(-valorExacto))||(resultadoNumerico>valorExacto))
            {
                return false;
            }
        }
        return resultado;
    }

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
    </head>
    <body>
        <form>
             <%
                    String codLote=request.getParameter("codLote");
                    String codComprod="";
                    String nombreProducto="";
                    String nombreForma="";
                    String nombreAnalisis="";
                    String nombreEspecificacion="";
                    String nombreReferencia="";
                    String resultado="";
                    String codEspecificacion="";
                    String nombreMaterial="";
                    String nombreAnalista="";
                    String nombrePresentacion="";
                    String nroAnalisis="";
                    String nombreJefeControldeCalidad="";
                    String fechaElaboracion="";
                    String fechaVencimiento="";
                    SimpleDateFormat sdt= new SimpleDateFormat("dd/MM/yyyy");
                    String tamLote="";
                    String nombreAreaEmpresa="";
                    boolean aprobado=true;
                    NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat formato = (DecimalFormat) numeroformato;
                        formato.applyPattern("#,##0.00");
                    int codDescriptivo=0;
                    Connection con=null;
                    try{
                        con=Util.openConnection(con);
                        String consulta="select ae.NOMBRE_AREA_EMPRESA, ra.NRO_ANALISIS,cp.VIDA_UTIL,cp.nombre_prod_semiterminado,cp.COD_COMPPROD,"+
                                        " ff.nombre_forma,(p.NOMBRE_PILA + ' '+ p.AP_PATERNO_PERSONAL + ' ' +"+
                                        " p.AP_MATERNO_PERSONAL) as nombreAnalista,pp.NOMBRE_PRODUCTO_PRESENTACION,"+
                                        " ISNULL((select top 1 spp.FECHA_INICIO from SEGUIMIENTO_PROGRAMA_PRODUCCION spp inner join"+
                                        " ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA=spp.COD_ACTIVIDAD_PROGRAMA"+
                                        " and spp.COD_FORMULA_MAESTRA=afm.COD_FORMULA_MAESTRA"+
                                        " where spp.COD_LOTE_PRODUCCION=ra.COD_LOTE and afm.COD_ACTIVIDAD =186 order by spp.FECHA_FINAL DESC),(select top 1 spp1.FECHA_INICIO from SEGUIMIENTO_PROGRAMA_PRODUCCION spp1 inner join"+
                                        " ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA=spp1.COD_ACTIVIDAD_PROGRAMA"+
                                        " and spp1.COD_FORMULA_MAESTRA=afm.COD_FORMULA_MAESTRA"+
                                        " where spp1.COD_LOTE_PRODUCCION=ra.COD_LOTE and afm.COD_ACTIVIDAD =76 order by spp1.FECHA_FINAL DESC)) as fecha,"+
                                        " (select top 1 (CAST(pp1.CANT_LOTE_PRODUCCION as varchar)+' u '+tpp.NOMBRE_TIPO_PROGRAMA_PROD) from PROGRAMA_PRODUCCION pp1 inner join"+
                                        " TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp1.COD_TIPO_PROGRAMA_PROD where"+
                                        " pp1.COD_LOTE_PRODUCCION=ra.COD_LOTE and   pp1.COD_COMPPROD = ra.COD_COMPROD "+
                                        " order by case pp1.COD_ESTADO_PROGRAMA when 6 then 1 when 7 then 2 when 2 then 3 else 4 end) as cant"+
                                        " from RESULTADO_ANALISIS ra inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = ra.COD_COMPROD"+
                                        " inner join FORMAS_FARMACEUTICAS ff on ff.cod_forma = cp.COD_FORMA"+
                                        " inner join PERSONAL p on p.COD_PERSONAL = ra.COD_PERSONAL_ANALISTA"+
                                        " inner join COMPONENTES_PRESPROD cpp on cpp.COD_COMPPROD = cp.COD_COMPPROD"+
                                        " inner join PRESENTACIONES_PRODUCTO pp on pp.cod_presentacion ="+
                                        " cpp.COD_PRESENTACION " +
                                        " inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=cp.COD_AREA_EMPRESA where ra.COD_LOTE = '"+codLote+"'";
                        System.out.println("consulta cabecera "+consulta);
                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet res=st.executeQuery(consulta);
                        Statement stdetalle=null;
                        ResultSet resdetalle=null;
                        if(res.next())
                        {
                            nombreProducto=res.getString("nombre_prod_semiterminado");
                            codComprod=res.getString("COD_COMPPROD");
                            nombreForma=res.getString("nombre_forma");
                            nroAnalisis=res.getString("NRO_ANALISIS");
                            nombreAnalista=res.getString("nombreAnalista");
                            nombrePresentacion=res.getString("NOMBRE_PRODUCTO_PRESENTACION");
                            tamLote=res.getString("cant");
                            nombreAreaEmpresa=res.getString("NOMBRE_AREA_EMPRESA");
                            if(res.getDate("fecha")!=null)
                                {
                            fechaElaboracion=sdt.format(res.getDate("fecha"));
                            int vidaUtil=res.getInt("VIDA_UTIL");
                            int years=Integer.valueOf(vidaUtil/12);
                            vidaUtil-=(years*12);
                            String[] fecha=fechaElaboracion.split("/");
                            fechaVencimiento=String.valueOf(Integer.valueOf(fecha[1])+vidaUtil)+"/"+String.valueOf(Integer.valueOf(fecha[2])+years);
                            }
                        }
             %>
            <h4 align="center">CERTIFICADO DE ANÁLISIS <%=nombreAreaEmpresa%></h4>
            <h4 align="center">DEPARTAMENTO DE CONTROL DE CALIDAD</h4>
            
            <table width="90%" align="center"  style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >
                <tr>
                    <td><b>PRODUCTO:&nbsp;</b><%=nombreProducto%></td>
                    <td><b>LOTE:&nbsp;</b><%=codLote%></td>
                </tr>
                <tr>
                    <td><b>FORMA FARMACEUTICA:&nbsp;</b><%=nombreForma%></td>
                    <td><b>PRESENTACION:&nbsp;</b><%=nombrePresentacion%></td>
                </tr>
                <tr>
                    <td><b>FECHA DE ELABORACIÓN:&nbsp;</b><%=fechaElaboracion%></td>
                    <td><b>FECHA DE VENCIMIENTO:&nbsp;</b><%=fechaVencimiento%></td>
                </tr>
                <tr>
                    <td><b>TAMAÑO DEL LOTE:&nbsp;</b><%=tamLote%></td>
                    <td><b>N° ANÁLISIS:&nbsp;</b><%=nroAnalisis%></td>
                </tr>
                
            </table>
          
           
             <table width="90%" align="center" class="outputText0" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >

             <tr bgcolor="#dddddd">
                    <td class='border' align='center' style='border:1px solid #cccccc;padding:8px'><b>ANALISIS FISICO</b></td>
                    <td class='border' align='center' style='border:1px solid #cccccc;padding:8px'><b>ESPECIFICACIONES</b></td>
                    <td class='border' align='center' style='border:1px solid #cccccc;padding:8px'><b>REFERENCIA</b></td>
                    <td class='border' align='center' style='border:1px solid #cccccc;padding:8px'><b>RESULTADOS</b></td>

              </tr>
                <%
                consulta="select rae.COD_TIPO_RESULTADO_DESCRIPTIVO,efcc.NOMBRE_ESPECIFICACION,efp.LIMITE_INFERIOR,efp.LIMITE_SUPERIOR,efp.VALOR_EXACTO,efp.DESCRIPCION,tr.NOMBRE_REFERENCIACC,trd.NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,"+
                         " rae.RESULTADO_NUMERICO,efcc.COD_TIPO_RESULTADO_ANALISIS," +
                         "ISNULL(tra.SIMBOLO,'')as SIMBOLO,ISNULL(efcc.COEFICIENTE,'') as COEFICIENTE,ISNULL(efcc.unidad,'') as unidad"+
                         " from ESPECIFICACIONES_FISICAS_PRODUCTO efp inner join ESPECIFICACIONES_FISICAS_CC efcc"+
                         " on efp.COD_ESPECIFICACION=efcc.COD_ESPECIFICACION inner join TIPOS_REFERENCIACC tr on"+
                         " tr.COD_REFERENCIACC=efp.COD_REFERENCIA_CC "+
                         " inner join RESULTADO_ANALISIS_ESPECIFICACIONES rae on rae.COD_TIPO_ANALISIS=1"+
                         " and  rae.COD_ESPECIFICACION=efcc.COD_ESPECIFICACION left outer join TIPO_RESULTADO_DESCRIPTIVO trd"+
                         " on trd.COD_TIPO_RESULTADO_DESCRIPTIVO=rae.COD_TIPO_RESULTADO_DESCRIPTIVO" +
                         " left outer join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS=efcc.COD_TIPO_RESULTADO_ANALISIS"+
                         " where efp.COD_PRODUCTO='"+codComprod+"'"+
                         " and rae.COD_LOTE='"+codLote+"' order by efcc.NOMBRE_ESPECIFICACION";
                System.out.println("consulta analisis fisico "+consulta);
                res=st.executeQuery(consulta);
                double limiteSuperior=0d;
                double limiteInferior=0d;
                double valorExacto=0d;
                double resultadoNumerico=0d;
                String codTipoResultadoAnalisis="";
                String simbolo="";
                String coeficiente="";
                String unidad="";
                String descripcion="";
                boolean conExponente=false;
                while(res.next())
                    {
                    nombreAnalisis=res.getString("NOMBRE_ESPECIFICACION");
                    codTipoResultadoAnalisis=res.getString("COD_TIPO_RESULTADO_ANALISIS");
                    nombreReferencia=res.getString("NOMBRE_REFERENCIACC");
                    limiteInferior=res.getDouble("LIMITE_INFERIOR");
                    limiteSuperior=res.getDouble("LIMITE_SUPERIOR");
                    valorExacto=res.getDouble("VALOR_EXACTO");
                    resultadoNumerico=res.getDouble("RESULTADO_NUMERICO");
                    simbolo=res.getString("SIMBOLO");
                    coeficiente=res.getString("COEFICIENTE");
                    unidad=res.getString("unidad");
                    nombreEspecificacion=((codTipoResultadoAnalisis.equals("1")?res.getString("DESCRIPCION"):
                        (codTipoResultadoAnalisis.equals("2")?(String.valueOf(limiteInferior)+" "+unidad+"-"+String.valueOf(limiteSuperior)+" "+unidad):
                        (coeficiente+" "+simbolo+" "+String.valueOf(valorExacto)+" "+unidad))));
                    resultado=(codTipoResultadoAnalisis.equals("1")?res.getString("NOMBRE_TIPO_RESULTADO_DESCRIPTIVO"):String.valueOf(resultadoNumerico));
                    if(!verificarResultadoAprobar(codTipoResultadoAnalisis,res.getString("COD_TIPO_RESULTADO_DESCRIPTIVO"), resultadoNumerico, limiteSuperior, limiteInferior, valorExacto))
                    {
                        aprobado=false;
                    }
                    

                %>
                 <tr >
                    <td class='border' align='left'  ><%=nombreAnalisis%></td>
                    <td class='border' align='left' ><%=nombreEspecificacion%></td>
                    <td class='border' align='left' ><%=nombreReferencia%></td>
                    <td class='border' align='left' ><%=(resultado+' '+unidad)%></td>
                   </tr>
                <%
                }
                
                %>
              <tr bgcolor="#dddddd">
                    <td class='border' align='center' style='border:1px solid #cccccc;padding:8px' colspan="4"><b>ANALISIS QUIMICO</b></td>
              </tr>
              <%
              consulta="select eqcc.COD_ESPECIFICACION,eqcc.NOMBRE_ESPECIFICACION,eqcc.COD_TIPO_RESULTADO_ANALISIS," +
                       " ISNULL(eqcc.COEFICIENTE,'') as COEFICIENTE,ISNULL(tra.SIMBOLO,'') as SIMBOLO,ISNULL(eqcc.UNIDAD,'') AS unidad"+
                       " from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp inner join"+
                       " ESPECIFICACIONES_QUIMICAS_CC eqcc on eqp.COD_ESPECIFICACION=eqcc.COD_ESPECIFICACION" +
                       " left outer join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS=eqcc.COD_TIPO_RESULTADO_ANALISIS"+
                       " where eqp.COD_PRODUCTO='"+codComprod+"'  and eqp.ESTADO=1 "+
                       " group by eqcc.UNIDAD,eqcc.COD_ESPECIFICACION,eqcc.NOMBRE_ESPECIFICACION,eqcc.COD_TIPO_RESULTADO_ANALISIS,eqcc.COEFICIENTE,tra.SIMBOLO";
              System.out.println("consulta especificaciones quimicas "+consulta);
              stdetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);

              res=st.executeQuery(consulta);
              while(res.next())
              {
                  unidad=res.getString("unidad");
                  coeficiente=res.getString("COEFICIENTE");
                  simbolo=res.getString("SIMBOLO");
                  nombreAnalisis=res.getString("NOMBRE_ESPECIFICACION");
                  codEspecificacion=res.getString("COD_ESPECIFICACION");
                  codTipoResultadoAnalisis=res.getString("COD_TIPO_RESULTADO_ANALISIS");
                  %>
                  <tr bgcolor="#eeeeee" >
                    <td class='border' align='left' colspan="4" ><b><%=nombreAnalisis%></b></td>
                    </tr>
                  <%
                  consulta="select m.NOMBRE_MATERIAL,eqp.DESCRIPCION,eqp.LIMITE_INFERIOR,eqp.LIMITE_SUPERIOR,eqp.VALOR_EXACTO,"+
                           " tr.NOMBRE_REFERENCIACC,raeq.RESULTADO_NUMERICO,"+
                           " trd.NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,trd.COD_TIPO_RESULTADO_DESCRIPTIVO"+
                           " from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp inner join MATERIALES m "+
                           " on m.COD_MATERIAL=eqp.COD_MATERIAL inner join TIPOS_REFERENCIACC tr on tr.COD_REFERENCIACC=eqp.COD_REFERENCIA_CC"+
                           " inner join RESULTADO_ANALISIS_ESPECIFICACIONES_QUIMICAS raeq on "+
                           " raeq.COD_ESPECIFICACION=eqp.COD_ESPECIFICACION and raeq.COD_MATERIAL=eqp.COD_MATERIAL "+
                           " left outer join TIPO_RESULTADO_DESCRIPTIVO trd on trd.COD_TIPO_RESULTADO_DESCRIPTIVO=raeq.COD_TIPO_RESULTADO_DESCRIPTIVO"+
                           " where eqp.COD_ESPECIFICACION='"+codEspecificacion+"' and eqp.COD_PRODUCTO='"+codComprod+"' and eqp.ESTADO=1"+
                           " and raeq.COD_LOTE='"+codLote+"' order by m.NOMBRE_MATERIAL";
                  System.out.println("consulta detalle analisis quimicos "+consulta);

                  resdetalle=stdetalle.executeQuery(consulta);
                  while(resdetalle.next())
                  {
                      nombreMaterial=resdetalle.getString("NOMBRE_MATERIAL");
                      nombreReferencia=resdetalle.getString("NOMBRE_REFERENCIACC");
                      limiteInferior=resdetalle.getDouble("LIMITE_INFERIOR");
                      limiteSuperior=resdetalle.getDouble("LIMITE_SUPERIOR");
                      valorExacto=resdetalle.getDouble("VALOR_EXACTO");
                      resultadoNumerico=resdetalle.getDouble("RESULTADO_NUMERICO");
                       nombreEspecificacion=(codTipoResultadoAnalisis.equals("1")?resdetalle.getString("DESCRIPCION"):
                           (codTipoResultadoAnalisis.equals("2")?(String.valueOf(limiteInferior)+" "+unidad+ "-"+String.valueOf(limiteSuperior)+" "+unidad) :
                            (coeficiente+" "+simbolo+" "+String.valueOf(valorExacto)+" "+unidad)));
                       resultado=(codTipoResultadoAnalisis.equals("1")?resdetalle.getString("NOMBRE_TIPO_RESULTADO_DESCRIPTIVO"):
                           String.valueOf(resultadoNumerico));
                        if(!verificarResultadoAprobar(codTipoResultadoAnalisis, resdetalle.getString("COD_TIPO_RESULTADO_DESCRIPTIVO"),
                        resultadoNumerico, limiteSuperior, limiteInferior, valorExacto))
                        {
                            aprobado=false;
                        }
                       %>
                    <tr >
                    <td class='border' align='left' ><%=nombreMaterial%></td>
                    <td class='border' align='left' ><%=nombreEspecificacion%></td>
                    <td class='border' align='left' ><%=nombreReferencia%></td>
                    <td class='border' align='left' ><%=(resultado+' '+unidad)%></td>
                    </tr>
                  <%

                  }
                  resdetalle.close();

              }

              stdetalle.close();

              %>
             <tr bgcolor="#dddddd">
                    <td class='border' align='center' style='border:1px solid #CCCCCC;padding:8px' colspan="4"><b>ANALISIS MICROBIOLOGICO</b>(Control de Esterilidad)</td>
              </tr>
             <%
             consulta="select em.NOMBRE_ESPECIFICACION,emp.LIMITE_INFERIOR,emp.LIMITE_SUPERIOR,emp.VALOR_EXACTO,emp.DESCRIPCION,tr.NOMBRE_REFERENCIACC,trd.NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,"+
                      " rae.RESULTADO_NUMERICO,em.COD_TIPO_RESULTADO_ANALISIS,ISNULL(em.COEFICIENTE,'') as COEFICIENTE,ISNULL(tra.SIMBOLO,'') as SIMBOLO,trd.COD_TIPO_RESULTADO_DESCRIPTIVO" +
                      " ,ISNULL(em.unidad,'') as unidad"+
                      " from ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO emp inner join ESPECIFICACIONES_MICROBIOLOGIA em on "+
                      " emp.COD_ESPECIFICACION = em.COD_ESPECIFICACION inner join TIPOS_REFERENCIACC tr on "+
                      " tr.COD_REFERENCIACC = emp.COD_REFERENCIA_CC inner join RESULTADO_ANALISIS_ESPECIFICACIONES rae on"+
                      " rae.COD_TIPO_ANALISIS = 3 and "+
                      " rae.COD_ESPECIFICACION = emp.COD_ESPECIFICACION left outer JOIN TIPO_RESULTADO_DESCRIPTIVO trd on "+
                      " trd.COD_TIPO_RESULTADO_DESCRIPTIVO=rae.COD_TIPO_RESULTADO_DESCRIPTIVO" +
                      " left outer join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS=em.COD_TIPO_RESULTADO_ANALISIS"+
                      " where emp.COD_COMPROD = '"+codComprod+"' "+
                      " and rae.COD_LOTE='"+codLote+"' order by em.NOMBRE_ESPECIFICACION";
             System.out.println("consulta detalle microbiologia "+consulta);
             res=st.executeQuery(consulta);
             while(res.next())
                 {
                    unidad=res.getString("unidad");
                    nombreAnalisis=res.getString("NOMBRE_ESPECIFICACION");
                    codTipoResultadoAnalisis=res.getString("COD_TIPO_RESULTADO_ANALISIS");
                    nombreReferencia=res.getString("NOMBRE_REFERENCIACC");
                    limiteInferior=res.getDouble("LIMITE_INFERIOR");
                    limiteSuperior=res.getDouble("LIMITE_SUPERIOR");
                    resultadoNumerico=res.getDouble("RESULTADO_NUMERICO");
                    valorExacto=res.getDouble("VALOR_EXACTO");
                    simbolo=res.getString("SIMBOLO");
                    coeficiente=res.getString("COEFICIENTE");
                    descripcion=res.getString("DESCRIPCION");
                    nombreEspecificacion=(codTipoResultadoAnalisis.equals("1")?descripcion:
                        (codTipoResultadoAnalisis.equals("2")?(String.valueOf(limiteInferior)+" "+unidad+"-"+String.valueOf(limiteSuperior)+" "+unidad):
                        (coeficiente+" "+simbolo+" "+valorExacto+" "+unidad)));
                    resultado=(codTipoResultadoAnalisis.equals("1")?res.getString("NOMBRE_TIPO_RESULTADO_DESCRIPTIVO"):
                        String.valueOf(resultadoNumerico));
                    if(!verificarResultadoAprobar(codTipoResultadoAnalisis,res.getString("COD_TIPO_RESULTADO_DESCRIPTIVO"), resultadoNumerico, limiteSuperior, limiteInferior, valorExacto))
                    {
                        aprobado=false;
                    }
                    conExponente=(descripcion.split("\\^").length>1);
                    
                    
                    %>
                 <tr >
                    <td class='border' align='left'  ><%=nombreAnalisis%></td>
                    <%
                    if(conExponente)
                    {
                        out.println("<td class='border' align='left' ><div style='position:relative;'>"+descripcion.split("\\^")[0]+"<span style='font-size:7px;position:absolute;top:0;rigth:20px'>"+descripcion.split("\\^")[1]+"</span></div></td>");
                        }
                    else
                        {
                            out.println("<td class='border' align='left' >"+nombreEspecificacion+"</td>");
                    }

                    %>
                    
                    <td class='border' align='left' ><%=nombreReferencia%></td>
                    <td class='border' align='left' ><%=(resultado+' '+unidad)%></td>
                   </tr>
                <%
                 }
              consulta="select (ga.ABREVIATURA_GRADO_ACADEMICO+' '+p.NOMBRE_PILA+' '+p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL) as jefe from PERSONAL p inner join GRADOS_ACADEMICOS ga on ga.COD_GRADO_ACADEMICO=p.COD_GRADO_ACADEMICO "+
                      "where p.CODIGO_CARGO=1130 and p.COD_ESTADO_PERSONA=1";
            res=st.executeQuery(consulta);
            while(res.next())
            {
                nombreJefeControldeCalidad=res.getString("jefe");
            }
            String observacion="";
            String dictamen="";
            if(aprobado)
            {
                observacion="Resultado de análisis dentro de los límites";
                dictamen="APROBADO";
            }
            else
            {
                observacion="Resultado de análisis fuera de los límites";
                dictamen="RECHAZADO";
            }
             %>
             
            </table>
            <table width="90%" align="center">
                 <tr>
                    <td  align='left' colspan="2"  ><b>OBSERVACIONES:&nbsp;</b><%=observacion%></td>
                    

              </tr>
              <tr>
                    <td  align='left'  ><b>DICTAMEN:&nbsp;<%=dictamen%></b></td>
                    <td  align='left' ><b>Fecha:&nbsp;</b><%=sdt.format(new Date())%></td>

              </tr>
              <tr>
                    <td  align='left'  ><b>RESULTADOS:&nbsp;</b><input type="text"></td>
                    <td  align='left' ><b>PÁGINA:&nbsp;</b><input type="text"></td>

              </tr>
            </table>
            <br><br><br><br><br><br>
            <table width="90%" align="center">
                 <tr>
                    <td  align='left'  ><b>Analista:&nbsp;</b><%=nombreAnalista%></td>
                    <td  align='left' ><b>Jefe Control de Calidad:&nbsp;</b><%=nombreJefeControldeCalidad%></td>

              </tr>
            </table>
            <%

            res.close();
            st.close();
            con.close();
            }
            catch(SQLException ex)
            {
                ex.printStackTrace();
            }
            %>
            </div>
        </form>
    </body>
</html>
