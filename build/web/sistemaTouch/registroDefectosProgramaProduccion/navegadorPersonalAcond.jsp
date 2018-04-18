<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../reponse/css/foundation.css" />
            <link rel="STYLESHEET" type="text/css" href="../reponse/css/AtlasWeb.css" />
            
            <script>
                 
                    
                 
              
                function validar(){                
                    return true;
                }
                function checkKey(key)
                {
                        var unicode
                        if (key.charCode)
                        {
                            unicode=key.charCode;
                        }
                        else
                        {
                            unicode=key.keyCode;
                        }
                        if (unicode == 13)
                        {
                            document.getElementById('form1:aceptar').click();
                        }

                }
                function verDefectos(codPersonal,nombrePersonal,codLote,codComprod,codTipoPP,codProgProd,cf)
                {
                    var a=Math.random();
                    
                    window.location.href='navegadorDefectosEnvase.jsf?nombrePersonal='+nombrePersonal+
                        '&codPersonal='+codPersonal+'&codLote='+codLote+'&codCompProd='+codComprod+
                        '&codTipoPP='+codTipoPP+'&codProgProd='+codProgProd+'&codForm='+cf+'&a='+a;
                    console.log('ddd');
                }
                function verReporteDefectosEncontrados(codLote,codComprod,codTipoPP,codProgProd,cf)
                {
                    var windowSizeArray = [ "scrollbars=yes" ];
                    var url1 ='reporteDefectosEncontrados.jsf?codCompProd='+codComprod+
                        '&codLote='+codLote+'&codTipoPP='+codTipoPP+
                        '&codProgProd='+codProgProd+'&codForm='+cf+
                        '&codP='+Math.random();
                    var windowName = "popUp_primerp1";
                    var windowSize = windowSizeArray[0];
                    window.open(url1, windowName, windowSize);

                }
            </script>
        </head>
        <body >
            
                
                <section class="main" style="margin-top:0px">
                    <div class="row"  style="margin-top:5px" >
                                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                                            <div class="row">
                                               <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                                       <label  class="inline" style="margin-bottom:auto">Datos del Lote</label>
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

                                                       <tr >
                                                           <%
                                                           try
                                                           {
                                                               String codComprod=request.getParameter("codCompProd");
                                                               String codLoteProduccion=request.getParameter("codLote");
                                                               String codTipoProgramaProd=request.getParameter("codTipoPP");
                                                               String codProgramaProd=request.getParameter("codProgProd");
                                                               String codFormula=request.getParameter("codFormula");
                                                               Connection con=null;
                                                               con=Util.openConnection(con);
                                                               Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                                               String consulta="select pp.CANT_LOTE_PRODUCCION,tpp.NOMBRE_TIPO_PROGRAMA_PROD"+
                                                                               ",cp.nombre_prod_semiterminado from PROGRAMA_PRODUCCION pp inner join TIPOS_PROGRAMA_PRODUCCION tpp"+
                                                                               " on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                                                               " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                                                                               " where pp.cod_estado_programa in (2,5,6,7) AND pp.COD_LOTE_PRODUCCION='"+codLoteProduccion+"' and pp.COD_COMPPROD='"+codComprod+"'"+
                                                                               " and pp.COD_FORMULA_MAESTRA='"+codFormula+"' and pp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' ";
                                                               System.out.println("consulta cabecera "+consulta);
                                                               ResultSet res=st.executeQuery(consulta);
                                                               while(res.next())
                                                               {
                                                                   %>
                                                                   <td class="tableCell" style="text-align:center">
                                                                       <span class="textHeaderClassBody"><%=codLoteProduccion%></span>
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
                                                                   <%
                                                               }
                                                               
                                                           %>
                                                           
                                                           
                                                       </tr>
                                                       </table>
                                                       </center>

                                             </div>
                                             </div>
                                         </div>
                            </div>







                     <div class="large-4 medium-5 small-6 large-centered medium-centered small-centered columns" style="margin-top:4px">

                        <div class="row">
                           <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                   <label  class="inline">Personal Acondicionamiento</label>
                            </div>
                        </div>
                        <div class="row">
                        <div  class="divContentClass large-12 medium-12 small-12 columns ">
                                
                                <div class="row" style="margin-top:5%;margin-bottom:5%">
                                    <div class="large-10 medium-10 small-10 columns large-centered medium-centered small-centered">
                                        <%
                                            consulta="select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+"+
                                                    " p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePersonal"+
                                                    "  from PERSONAL p where p.COD_ESTADO_PERSONA=1  and p.COD_AREA_EMPRESA in (102)"+
                                                    " order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,"+
                                                    " p.NOMBRES_PERSONAL,p.nombre2_personal";
                                            res=st.executeQuery(consulta);
                                            while(res.next())
                                                {
                                        %>
                                              <div class="row" >
                                                  <div class="large-12 medium-12 small-12 columns divMenuItem" 
                                                  onclick="verDefectos('<%=res.getString("COD_PERSONAL")%>','<%=res.getString("nombrePersonal")%>','<%=codLoteProduccion%>','<%=codComprod%>','<%=codTipoProgramaProd%>','<%=codProgramaProd%>','<%=codFormula%>')">
                                                    <label>
                                                        <span class="textHeaderClass"><%=res.getString("nombrePersonal")%></span>
                                                    </label>
                                                    </div>
                                              </div>
                                         <%
                                                }
                                         %>
                                    </div>
                                </div>
                               
                                 <div class="row">
                                        
                                                    <div class="large-10 medium-10 small-10 large-centered medium-centered small-centered  columns">
                                                        <input type="button" onclick="window.location.href='navProgProduccion.jsf?cod='+Math.random();" class="small button succes radius buttonAction" value="Cancelar">
                                                        

                                                    </div>
                                           
                                    </div>
                                    <div class="row">

                                                    <div class="large-10 medium-10 small-10 large-centered medium-centered small-centered  columns">
                                                        <input type="button" onclick="verReporteDefectosEncontrados('<%=codLoteProduccion%>','<%=codComprod%>','<%=codTipoProgramaProd%>','<%=codProgramaProd%>','<%=codFormula%>');" value="Ver Reporte Defectos" class="small button succes radius buttonAction" id="buttonGuardar">
                                                  

                                                    </div>

                                    </div>
                         </div>
                         </div>
                     </div>
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
                </section>
            
        </body>
    </html>
</f:view>


