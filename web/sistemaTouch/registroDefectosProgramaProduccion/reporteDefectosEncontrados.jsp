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


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../reponse/css/foundation.css" />
            <link rel="STYLESHEET" type="text/css" href="../reponse/css/AtlasWeb.css" />
        <script src="../js/general.js"></script>
        <style>
            .outputTextNormal{
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 9px;
                font-weight: normal;
            }
        </style>
        
    </head>
    <%! 
    Statement stDetalle=null;
        ResultSet resDetalle=null;
    String mostrarDetalle(String codLote,String codTipo,String codProgProd,String codCompProd,String codForm,String codPersonal,Connection con1)
    {
          NumberFormat n = NumberFormat.getNumberInstance(Locale.ENGLISH);
          DecimalFormat f = (DecimalFormat) n;
          f.applyPattern("####.##;(####.##)");
        String HTML="";
        try
        {
           String detalle="select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRE_PILA) as nombrePersonal"+
                                                " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp "+
                                                " inner join ACTIVIDADES_FORMULA_MAESTRA afm on sppp.COD_ACTIVIDAD_PROGRAMA = afm.COD_ACTIVIDAD_FORMULA"+
                                                " inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD=afm.COD_ACTIVIDAD"+
                                                " and ap.COD_ACTIVIDAD in (29,40,157) inner join personal p on sppp.COD_PERSONAL=p.COD_PERSONAL"+
                                                " where sppp.COD_COMPPROD='"+codCompProd+"'"+
                                                " and sppp.COD_FORMULA_MAESTRA='"+codForm+"'"+
                                                " and sppp.COD_LOTE_PRODUCCION='"+codLote+"'"+
                                                " and sppp.COD_PROGRAMA_PROD='"+codProgProd+"'"+
                                                " and sppp.COD_TIPO_PROGRAMA_PROD='"+codTipo+"'" +
                                                " group by p.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRE_PILA" +
                                                " order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRE_PILA";
           System.out.println("consulta detalle "+detalle);
           resDetalle=stDetalle.executeQuery(detalle);
           HTML+="<div><table width='70%' align='center' class='outputTextNormal' style='border : solid #D8D8D8 0px;' cellpadding='0' cellspacing='0' >";
           HTML+="<tr>";
           HTML+="<th class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' width='20%' align='center' ><b>Defectos</b></th>";
           Statement st1=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
           ResultSet res1=null;
           String consulta="";
           List<String> rowsData=new ArrayList<String>();
           boolean primeraVez=true;
           int cont=0;
           while(resDetalle.next())
           {
                
                HTML+="<th class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' width='20%' align='center' ><b>"+resDetalle.getString("nombrePersonal")+"</b></th>";
                consulta="select de.COD_DEFECTO_ENVASE,de.NOMBRE_DEFECTO_ENVASE,ISNULL(depp.CANTIDAD_DEFECTOS_ENCONTRADOS,0) as CANTIDAD_DEFECTOS_ENCONTRADOS"+
                         " from DEFECTOS_ENVASE de left outer join DEFECTOS_ENVASE_PROGRAMA_PRODUCCION depp"+
                         " on de.COD_DEFECTO_ENVASE=depp.COD_DEFECTO_ENVASE "+
                         " and depp.COD_FORMULA_MAESTRA='"+codForm+"'"+
                        " and depp.COD_COMPPROD='"+codCompProd+"'"+
                        " and depp.COD_LOTE_PRODUCCION='"+codLote+"'"+
                        " and depp.COD_PERSONAL='"+codPersonal+"'"+
                        " and depp.COD_PROGRAMA_PROD='"+codProgProd+"'"+
                        " and depp.COD_TIPO_PROGRAMA_PROD='"+codTipo+"'" +
                        " and depp.COD_PERSONAL_OPERARIO='"+resDetalle.getString("COD_PERSONAL")+"'"+
                        " and de.cod_estado_registro=1 order by de.ORDEN";
                System.out.println("consulta buscar defectos por personal "+consulta);
                res1=st1.executeQuery(consulta);
                cont=0;
                double suma=0d;
                while(res1.next())
                {
                    if(primeraVez)
                    {
                        rowsData.add("<tr><th  class='border' style='border : solid #D8D8D8 1px;font-weight:normal'  width='20%' align='center'>"+res1.getString("NOMBRE_DEFECTO_ENVASE")+"</th>" +
                                "<th  class='border' style='border : solid #D8D8D8 1px;font-weight:normal;'  width='20%' align='center'>"+f.format(res1.getDouble("CANTIDAD_DEFECTOS_ENCONTRADOS"))+"</th>");
                        suma+=res1.getDouble("CANTIDAD_DEFECTOS_ENCONTRADOS");
                    }
                    else
                    {
                        rowsData.set(cont,(rowsData.get(cont)+"<th  class='border' style='border : solid #D8D8D8 1px;font-weight:normal;'  width='20%' align='center'>"+f.format(res1.getDouble("CANTIDAD_DEFECTOS_ENCONTRADOS"))+"</th>"));
                        suma+=res1.getDouble("CANTIDAD_DEFECTOS_ENCONTRADOS");
                        cont++;
                    }
                }
                if(primeraVez)
                {
                    rowsData.add("<tr><th  class='border' style='border : solid #D8D8D8 1px;font-weight:normal'  width='20%' align='center'><b>TOTALES: </b></th>" +
                                "<th  class='border' style='border : solid #D8D8D8 1px;font-weight:normal;'  width='20%' align='center'>"+f.format(suma)+"</th>");
                }
                else
                {
                    rowsData.set(cont,(rowsData.get(cont)+"<th  class='border' style='border : solid #D8D8D8 1px;font-weight:normal;'  width='20%' align='center'>"+f.format(suma)+"</th>"));
                }
                res1.close();
                primeraVez=false;
           }
           st1.close();
           HTML+="</tr>";
           for(String var:rowsData)
           {
               HTML+=var+"<tr>";
           }
           HTML+="</table></div>";
           resDetalle.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }

        return HTML;
    }
    %>
    <body>
      
        <form>
           <section class="main" style="margin-top:0px">
               <%
               String codComprod=request.getParameter("codCompProd");
               String codFormula=request.getParameter("codForm");
               String codLote=request.getParameter("codLote");
               String codProgProd=request.getParameter("codProgProd");
               String codTipoPP=request.getParameter("codTipoPP");
               %>
                    <div class="row"  style="margin-top:5px" >
                                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                                            <div class="row">
                                               <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                                       <label  class="inline" style="margin-bottom:auto">Reporte de Defectos Por Lote</label>
                                                </div>
                                            </div>
                                            <div class="row" >

                                            <div  class="divContentClass large-12 medium-12 small-12 columns">
                                                    <center>
                                                   <table style="width:96%;margin-top:5px;margin-bottom:5px" cellpadding="0px" cellspacing="0px">
                                                       <tr >
                                                           <td class="tableHeaderClass" style="text-align:center">
                                                               <span class="textHeaderClass">Lote</span>
                                                           </td>
                                                           <td class="tableHeaderClass" style="text-align:center;">
                                                               <span class="textHeaderClass">Tam. Lote</span>
                                                           </td>
                                                           <td class="tableHeaderClass" style="text-align:center">
                                                               <span class="textHeaderClass">Producto</span>
                                                           </td>
                                                           <td class="tableHeaderClass" style="text-align:center">
                                                               <span class="textHeaderClass">Tipo Programa</span>
                                                           </td>

                                                       </tr>
                                                       <%
                                                       try
                                                       {
                                                               Connection con=null;
                                                               con=Util.openConnection(con);
                                                               Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                                               String consulta="select pp.CANT_LOTE_PRODUCCION,tpp.NOMBRE_TIPO_PROGRAMA_PROD"+
                                                                               ",cp.nombre_prod_semiterminado from PROGRAMA_PRODUCCION pp inner join TIPOS_PROGRAMA_PRODUCCION tpp"+
                                                                               " on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                                                               " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                                                                               " where pp.cod_estado_programa in (2,5,6,7) AND pp.COD_LOTE_PRODUCCION='"+codLote+"' and pp.COD_COMPPROD='"+codComprod+"'"+
                                                                               " and pp.COD_FORMULA_MAESTRA='"+codFormula+"' and pp.COD_TIPO_PROGRAMA_PROD='"+codTipoPP+"' and pp.COD_PROGRAMA_PROD='"+codProgProd+"'";
                                                               System.out.println("consulta cabecera "+consulta);
                                                               ResultSet res=st.executeQuery(consulta);
                                                               while(res.next())
                                                               {
                                                       %>
                                                       <tr >
                                                           <td class="tableCell" style="text-align:center">
                                                               <span class="textHeaderClassBody"><%=codLote%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center;">
                                                               <span class="textHeaderClassBody"><%=res.getString("CANT_LOTE_PRODUCCION")%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center">
                                                               <span class="textHeaderClassBody"><%=res.getString("nombre_prod_semiterminado")%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center">
                                                               <span class="textHeaderClassBody"><%=res.getString("NOMBRE_TIPO_PROGRAMA_PROD")%></span>
                                                           </td>

                                                       </tr>
                                                       <%
                                                               }
                                                       %>
                                                       </table>
                                                       </center>

                                             </div>
                                             </div>
                                         </div>
                            </div>
            
             <div class="row" style="margin-top:12px;">
                 <div class="large-10 medium-10 small-12 large-centered medium-centered columns ">
                    <table width="100%" align="center" class="outputTextNormal"  cellpadding="0" cellspacing="0" >

                        <tr class="tableHeaderClass">
                            <td class="tableHeaderClass" align="center"  ><span class="textHeaderClass">Personal</span></td>
                            <td class="tableHeaderClass" align="center" ><span class="textHeaderClass">Defectos Encontrados</span></td>
                        </tr>
                            <%
                              NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                                DecimalFormat formato = (DecimalFormat) numeroformato;
                                formato.applyPattern("####.##;(####.##)");

                                SimpleDateFormat format=new SimpleDateFormat("dd/MM/yyyy");


                                consulta=" select depp.COD_COMPPROD,depp.COD_PERSONAL,depp.COD_FORMULA_MAESTRA,depp.COD_PROGRAMA_PROD,depp.COD_TIPO_PROGRAMA_PROD,ppp.NOMBRE_PROGRAMA_PROD,depp.COD_LOTE_PRODUCCION,cp.nombre_prod_semiterminado,"+
                                                " tpp.NOMBRE_TIPO_PROGRAMA_PROD,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRE_PILA) as nombrePersonal"+
                                                " from DEFECTOS_ENVASE_PROGRAMA_PRODUCCION depp"+
                                                " inner join COMPONENTES_PROD cp ON depp.COD_COMPPROD = cp.COD_COMPPROD"+
                                                " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD ="+
                                                " depp.COD_TIPO_PROGRAMA_PROD"+
                                                " inner join PROGRAMA_PRODUCCION_PERIODO ppp on depp.COD_PROGRAMA_PROD ="+
                                                " ppp.COD_PROGRAMA_PROD"+
                                                " inner join PERSONAL p on depp.COD_PERSONAL=p.COD_PERSONAL"+
                                                " where depp.COD_PROGRAMA_PROD = "+codProgProd+" and"+
                                                " depp.COD_LOTE_PRODUCCION ='"+codLote+"'" +
                                                "  and depp.COD_COMPPROD ='"+codComprod+"'"+
                                                " and depp.COD_TIPO_PROGRAMA_PROD ='"+codTipoPP+"'"+
                                                " and depp.COD_FORMULA_MAESTRA='"+codFormula+"'"+
                                                " group by depp.COD_COMPPROD,depp.COD_PERSONAL,depp.COD_FORMULA_MAESTRA,depp.COD_PROGRAMA_PROD,depp.COD_TIPO_PROGRAMA_PROD,ppp.NOMBRE_PROGRAMA_PROD,"+
                                                " depp.COD_LOTE_PRODUCCION,cp.nombre_prod_semiterminado,tpp.NOMBRE_TIPO_PROGRAMA_PROD,"+
                                                " p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRE_PILA"+
                                                " order by ppp.NOMBRE_PROGRAMA_PROD,depp.COD_LOTE_PRODUCCION,cp.nombre_prod_semiterminado,"+
                                                " tpp.NOMBRE_TIPO_PROGRAMA_PROD,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRE_PILA" ;
                                        System.out.println("consulta buscar personal"+consulta);
                                        res=st.executeQuery(consulta);
                                        stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet resDetalle=null;
                                        String mostrar="";
                                        int cont=0;

                                        while(res.next())
                                        {
                                            
                                            
                                            mostrar+="<tr><td class='tableCell textHeaderClassBody' align='center'>"+res.getString("nombrePersonal")+"</td>"+
                                            "<td class='tableCell textHeaderClassBody'>";
                                            NumberFormat n = NumberFormat.getNumberInstance(Locale.ENGLISH);
                                            DecimalFormat f = (DecimalFormat) n;
                                                  f.applyPattern("####.##;(####.##)");
                                                String HTML="";

                                                   String detalle="select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRE_PILA) as nombrePersonal"+
                                                                                        " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp "+
                                                                                        " inner join ACTIVIDADES_FORMULA_MAESTRA afm on sppp.COD_ACTIVIDAD_PROGRAMA = afm.COD_ACTIVIDAD_FORMULA"+
                                                                                        " inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD=afm.COD_ACTIVIDAD"+
                                                                                        " and ap.COD_ACTIVIDAD in (29,40,157) inner join personal p on sppp.COD_PERSONAL=p.COD_PERSONAL"+
                                                                                        " where sppp.COD_COMPPROD='"+codComprod+"'"+
                                                                                        " and sppp.COD_FORMULA_MAESTRA='"+codFormula+"'"+
                                                                                        " and sppp.COD_LOTE_PRODUCCION='"+codLote+"'"+
                                                                                        " and sppp.COD_PROGRAMA_PROD='"+codProgProd+"'"+
                                                                                        " and sppp.COD_TIPO_PROGRAMA_PROD='"+codTipoPP+"'" +
                                                                                        " group by p.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRE_PILA" +
                                                                                        " order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRE_PILA";
                                                   System.out.println("consulta detalle "+detalle);
                                                   resDetalle=stDetalle.executeQuery(detalle);
                                                   HTML+="<div><table width='100%' align='center'  style='margin-top:0px;margin-left:0px;left:0px ;border : solid #D8D8D8 0px;' cellpadding='0' cellspacing='0' >";
                                                   HTML+="<tr class='tableHeaderClass'>";
                                                   HTML+="<th class='tableHeaderClass' align='center' ><span class='textHeaderClass'>Defectos</span></th>";
                                                   Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                                   ResultSet res1=null;
                                                   List<String> rowsData=new ArrayList<String>();
                                                   boolean primeraVez=true;
                                                   
                                                   while(resDetalle.next())
                                                   {

                                                        HTML+="<th class='tableHeaderClass' align='center' ><span class='textHeaderClass'>"+resDetalle.getString("nombrePersonal")+"<span class='textHeaderClass'></th>";
                                                        consulta="select de.COD_DEFECTO_ENVASE,de.NOMBRE_DEFECTO_ENVASE,ISNULL(depp.CANTIDAD_DEFECTOS_ENCONTRADOS,0) as CANTIDAD_DEFECTOS_ENCONTRADOS"+
                                                                 " from DEFECTOS_ENVASE de left outer join DEFECTOS_ENVASE_PROGRAMA_PRODUCCION depp"+
                                                                 " on de.COD_DEFECTO_ENVASE=depp.COD_DEFECTO_ENVASE "+
                                                                 " and depp.COD_FORMULA_MAESTRA='"+codFormula+"'"+
                                                                " and depp.COD_COMPPROD='"+codComprod+"'"+
                                                                " and depp.COD_LOTE_PRODUCCION='"+codLote+"'"+
                                                                " and depp.COD_PERSONAL='"+res.getString("COD_PERSONAL")+"'"+
                                                                " and depp.COD_PROGRAMA_PROD='"+codProgProd+"'"+
                                                                " and depp.COD_TIPO_PROGRAMA_PROD='"+codTipoPP+"'" +
                                                                " and depp.COD_PERSONAL_OPERARIO='"+resDetalle.getString("COD_PERSONAL")+"'"+
                                                                " and de.cod_estado_registro=1 order by de.ORDEN";
                                                        System.out.println("consulta buscar defectos por personal "+consulta);
                                                        res1=st1.executeQuery(consulta);
                                                        cont=0;
                                                        double suma=0d;
                                                        while(res1.next())
                                                        {
                                                            if(primeraVez)
                                                            {
                                                                rowsData.add("<tr><th  class='tableCell' style='text-align:center'>"+res1.getString("NOMBRE_DEFECTO_ENVASE")+"</th>" +
                                                                        "<th  class='tableCell' style='text-align:center'>"+f.format(res1.getDouble("CANTIDAD_DEFECTOS_ENCONTRADOS"))+"</th>");
                                                                suma+=res1.getDouble("CANTIDAD_DEFECTOS_ENCONTRADOS");
                                                            }
                                                            else
                                                            {
                                                                rowsData.set(cont,(rowsData.get(cont)+"<th  class='tableCell' style='text-align:center'>"+f.format(res1.getDouble("CANTIDAD_DEFECTOS_ENCONTRADOS"))+"</th>"));
                                                                suma+=res1.getDouble("CANTIDAD_DEFECTOS_ENCONTRADOS");
                                                                cont++;
                                                            }
                                                        }
                                                        if(primeraVez)
                                                        {
                                                            rowsData.add("<tr><th  class='tableCell' style='text-align:center;color:red;'><b>TOTALES: </b></th>" +
                                                                        "<th  class='tableCell' style='text-align:center;color:red;'><b>"+f.format(suma)+"</b></th>");
                                                        }
                                                        else
                                                        {
                                                            rowsData.set(cont,(rowsData.get(cont)+"<th  class='tableCell' style='text-align:center;color:red;'><b>"+f.format(suma)+"</b></th>"));
                                                        }
                                                        res1.close();
                                                        primeraVez=false;
                                                   }
                                                   st1.close();
                                                   HTML+="</tr>";
                                                   for(String var:rowsData)
                                                   {
                                                       HTML+=var+"<tr>";
                                                   }
                                                   HTML+="</table></div>";
                                                   resDetalle.close();
                                            mostrar+=HTML+ "</td></tr>";
                                            
                                            cont++;
                                        }
                                        mostrar+="<tr><td class='tableCell textHeaderClassBody' align='center'>Total Lote</td>"+
                                            "<td class='tableCell textHeaderClassBody'><table width='100%' align='center'  style='margin-top:0px;margin-left:0px;left:0px ;border : solid #D8D8D8 0px;' cellpadding='0' cellspacing='0' >" +
                                            "<tr class='tableHeaderClass'><th  class='tableHeaderClass' align='center' ><span class='textHeaderClass'>Defecto</span></th>"+
                                            "<th  class='tableHeaderClass' align='center' ><span class='textHeaderClass'>Cantidad Defectos Encontrados</span></th></tr>";

                                        consulta="select ppp.NOMBRE_PROGRAMA_PROD,depp.COD_LOTE_PRODUCCION,"+
                                        " cp.nombre_prod_semiterminado,tpp.NOMBRE_TIPO_PROGRAMA_PROD,de.NOMBRE_DEFECTO_ENVASE,"+
                                        " sum(depp.CANTIDAD_DEFECTOS_ENCONTRADOS) as cantidadDefectos"+
                                        " from DEFECTOS_ENVASE_PROGRAMA_PRODUCCION depp inner join COMPONENTES_PROD cp ON"+
                                        " depp.COD_COMPPROD=cp.COD_COMPPROD inner join TIPOS_PROGRAMA_PRODUCCION tpp"+
                                        " on tpp.COD_TIPO_PROGRAMA_PROD=depp.COD_TIPO_PROGRAMA_PROD "+
                                        " inner join PROGRAMA_PRODUCCION_PERIODO ppp on depp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD"+
                                        " inner join DEFECTOS_ENVASE de on de.COD_DEFECTO_ENVASE=depp.COD_DEFECTO_ENVASE"+
                                        " where depp.COD_PROGRAMA_PROD ='"+codProgProd+"' and"+
                                        " depp.COD_LOTE_PRODUCCION ='"+codLote+"' " +
                                        " and depp.COD_COMPPROD ='"+codComprod+"'" +
                                        " and depp.COD_TIPO_PROGRAMA_PROD ='"+codTipoPP+"'"+
                                        " and depp.COD_FORMULA_MAESTRA='"+codFormula+"'"+
                                        " group by  ppp.NOMBRE_PROGRAMA_PROD,depp.COD_LOTE_PRODUCCION,"+
                                        " cp.nombre_prod_semiterminado,tpp.NOMBRE_TIPO_PROGRAMA_PROD,de.NOMBRE_DEFECTO_ENVASE,de.orden"+
                                        " order by de.ORDEN";
                                        System.out.println("consulta buscar defectos "+consulta);
                                        res=st.executeQuery(consulta);
                                        while(res.next())
                                        {
                                         mostrar+="<tr><th class='tableCell'>"+res.getString("NOMBRE_DEFECTO_ENVASE")+"</th>"+
                                        "<th class='tableCell' align='right'>"+formato.format(res.getDouble("cantidadDefectos"))+"</th></tr>";
                                        }

                                
                                        mostrar+="</table></td>";
                                        out.println(mostrar);
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
                       </div>
               </div>
              </section>
            
            
                <%--<INPUT type="button" class="commandButton" name="btn_registrar" value="<-- Atrás" onClick="cancelar();"  >--%>

            
        </form>
    </body>
</html>