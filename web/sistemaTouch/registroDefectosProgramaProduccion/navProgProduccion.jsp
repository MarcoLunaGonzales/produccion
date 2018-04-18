<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<f:view>
    
    <html >
        <head >
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../reponse/css/foundation.css" />
            <link rel="STYLESHEET" type="text/css" href="../reponse/css/AtlasWeb.css" />
            
            <script language="javascript" type="text/javascript">
                var sizeModal=0;
               var myVar=null;
               var div1=null;
                function verModal()
                {
                    
                     div1=document.getElementById('divBuscar');
                     sizeModal=parseInt(div1.offsetWidth);
                     
                     div1.style.left=-sizeModal;
                     div1.style.visibility='visible';
                      clearInterval(myVar);
                     myVar=setInterval(function(){showModal()},40);
                }
                function  ocultarModal()
                {
                    
                    sizeModal=parseInt(div1.offsetWidth);
                    
                     clearInterval(myVar);
                    myVar=setInterval(function(){hideModal()},40);
                    document.getElementById('divLotesProduccion').blur();
                    document.getElementById('divLotesProduccion').focus();
                    window.scrollY='0px';
                    
                }
                function hideModal()
                {
                    if(sizeModal>0)
                    {
                        div1.style.left=sizeModal-div1.offsetWidth;
                        
                    }
                    else
                    {
                        div1.style.visibility='hidden';
                        
                        clearInterval(myVar);
                    }
                    sizeModal-=60;
                }
                function showModal()
                {
                    
                    if(sizeModal>0)
                    {
                        div1.style.left=-sizeModal;
                        
                    }
                    else
                    {
                        
                        
                        div1.style.left=0;
                        clearInterval(myVar);
                        
                    }
                    sizeModal-=60;
                }
                function openPopup(url){
                    //alert(url);
                    var a=Math.random();
                    window.open(url+'&a='+a,'DETALLE','top=50,left=200,width=800,height=500,scrollbars=1,resizable=1');
                }
                 function checkKey(key)
                {
                        var unicode;
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
                            document.getElementById('buttonBuscar').click();
                        }

                }
                function nuevoAjax()
                {	var xmlhttp=false;
                    try {
                        xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
                    } catch (e) {
                        try {
                            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                        } catch (E) {
                            xmlhttp = false;
                        }
                    }
                    if (!xmlhttp && typeof XMLHttpRequest!="undefined") {
                        xmlhttp = new XMLHttpRequest();
                    }

                    return xmlhttp;
                }
                function buscarLote()
                {

                    ajax=nuevoAjax();
                    var div_lotes=document.getElementById("divLotesProduccion");
                    var lote=document.getElementById("codLote");
                    var codProgProd=document.getElementById('codProgProd').value;
                    document.getElementById('formsuper').style.visibility='visible';
                    document.getElementById('divImagen').style.visibility='visible';
                    ajax.open("GET","ajaxLotesInyectables.jsf?codLote="+lote.value+"&codProgramaProd="+codProgProd+"&a="+Math.random(),true);
                    ajax.onreadystatechange=function(){
                        if (ajax.readyState==4) {
                            div_lotes.innerHTML=ajax.responseText;
                            document.getElementById('formsuper').style.visibility='hidden';
                            document.getElementById('divImagen').style.visibility='hidden';
                            ocultarModal();
                        }
                    }

                    ajax.send(null);


                }
            </script>
        </head>
        
           <body >
                    <div style="margin-top:2%;position:fixed;;width:100%;z-index:200;visibility:hidden" id="divImagen">
                         <center><img src="../reponse/img/load2.gif"  style="z-index:205; "><%--margin-top:2%;position:fixed;--%>
                         </center>
                     </div>
            
                 <section class="main" style="margin-top:5px;width:100%;border:1px solid blue;" >
                     <div id="buttonBuscar" onclick="verModal();" class="divBuscador" alt="buscar"><img src="../reponse/img/lupa.gif" style="width:100%" alt="Buscar" >  </div>
                     <div id="divBuscar" style="position: fixed;left:0%;z-index:100;margin-top: 1px;margin-right:0%;visibility:hidden">

                        <div class="row">
                           <div class="large-12 medium-12 small-12 columns divHeaderClass" onclick="ocultarModal()" >
                                   <label  class="inline">Buscador Lote programa Producción</label>
                            </div>
                        </div>
                        <div class="row">
                        <div  class="divContentClass large-12 medium-12 small-12 columns">

                                <div class="row" style="margin-top:12px">
                                    <div class="row " style="" >
                                            <div class="large-3 medium-3 small-10 columns">
                                            <label class="inline">Programa Produccion</label>
                                            </div>
                                            <div class="large-1 medium-1 small-2 columns">
                                            <label class="inline">:</label>
                                            </div>
                                            <div class="large-8 medium-8 small-12 columns">
                                            <select id="codProgProd">
                                                    <option value="0">-TODOS-</option>
                                                <%
                                                try
                                                {
                                                    Connection con=null;
                                                    con=Util.openConnection(con);
                                                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                                    ResultSet res=st.executeQuery("select ppp.COD_PROGRAMA_PROD,ppp.NOMBRE_PROGRAMA_PROD from PROGRAMA_PRODUCCION_PERIODO ppp where ppp.COD_ESTADO_PROGRAMA<>4 and ISNULL(ppp.COD_TIPO_PRODUCCION,1) in (1) order by ppp.COD_PROGRAMA_PROD");
                                                    while(res.next())
                                                    {
                                                        out.println("<option value='"+res.getString("COD_PROGRAMA_PROD")+"'>"+res.getString("NOMBRE_PROGRAMA_PROD")+"</option>");
                                                    }
                                                    st.close();
                                                    con.close();
                                                }
                                                catch(SQLException ex)
                                                {
                                                    ex.printStackTrace();
                                                }
                                                %>
                                                </select>
                                            </div>
                                    </div>
                                    <div class="row ">
                                            <div class="large-3 medium-3 small-10 columns">
                                            <label class="inline">Lote</label>
                                            </div>
                                            <div class="large-1 medium-1 small-2 columns">
                                            <label class="inline">:</label>
                                            </div>
                                            <div class="large-8 medium-8 small-12 columns">
                                                <input type="text" value="" class="inputText" id="codLote" onkeypress="checkKey(this)"/>
                                                
                                            </div>
                                    </div>

                                    <div class="large-6 small-8 madium-10 large-centered columns">
                                        <input type="button"class="small button succes radius" id="buttonBuscar" onclick="buscarLote();" value="Buscar Lote">

                                    </div>
                                </div>
                         </div>
                         </div>
                     </div>
                     <div class="row" style="width:100%;margin-top:0px">
                          <div class="large-12 medium-12 small-12 columns" id="divLotesProduccion">
                             <table cellpadding="0px" cellspacing="0px" style="width:100%">
                                 <tr><td class="tableHeaderClass" style="width:30%"><span class="textHeaderClass">Producto</span></td>
                                 <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Lote</span></td>
                                 <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Nro Lote</span></td>
                                 <td class="tableHeaderClass" style="width:20%"><span class="textHeaderClass">Tipo<br>Programa</span></td>
                                 <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Area</span></td>
                                 <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Estado</span></td>
                                 <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Defectos</span></td>

                             </table>
                          </div>
                         <%--rich:dataTable value="#{ManagedSeguimientoProgramaProduccionTouch.programaProduccionDataModel}" var="data"
                                 headerClass="" id="dataProgramaproduccionList" style="">

                                         <f:facet name="header">
                                             <rich:columnGroup>
                                                 <rich:column  style="width:30%" styleClass="tableHeaderClass">
                                                         <h:outputText value="Producto" styleClass="textHeaderClass" />
                                                        </rich:column>
                                                        <rich:column  style="width:10%" styleClass="tableHeaderClass">
                                                            <h:outputText value="Lote" styleClass="textHeaderClass" />
                                                        </rich:column>

                                                        <rich:column  style="width:10%" styleClass="tableHeaderClass">
                                                            <h:outputText value="Nro de Lote" styleClass="textHeaderClass" />
                                                        </rich:column >
                                                        <rich:column  style="width:10%" styleClass="tableHeaderClass">
                                                            <h:outputText value="Tipo Programa"  styleClass="textHeaderClass"/>
                                                        </rich:column>

                                                        <rich:column  style="width:20%" styleClass="tableHeaderClass">
                                                            <h:outputText value="Estado"   styleClass="textHeaderClass"/>
                                                        </rich:column >
                                                        <rich:column  style="width:10%" styleClass="tableHeaderClass">
                                                            <h:outputText value="Defectos"  styleClass="textHeaderClass"/>
                                                        </rich:column>
                                                        <rich:column style="width:10%" styleClass="tableHeaderClass">
                                                            <h:outputText value="Proceso Despiro" styleClass="textHeaderClass"  />
                                                        </rich:column>
                                                </rich:columnGroup>
                                         </f:facet>

                                     <rich:column style="width:30%" styleClass="tableCell">
                                         <h:outputText styleClass="textHeaderClassBody" value="#{data.formulaMaestra.componentesProd.nombreProdSemiterminado}"  />
                                    </rich:column>
                                    <rich:column style="width:10%" styleClass="tableCell">
                                        <h:outputText styleClass="textHeaderClassBody" value="#{data.cantidadLote}"  />
                                    </rich:column>

                                    <rich:column style="width:10%" styleClass="tableCell">
                                        <h:outputText styleClass="textHeaderClassBody" value="#{data.codLoteProduccion}"  />
                                    </rich:column >


                                    <rich:column style="width:10%" styleClass="tableCell">
                                        <h:outputText styleClass="textHeaderClassBody" value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}"/>
                                    </rich:column>


                                    <rich:column style="width:20%" styleClass="tableCell">
                                        <h:outputText styleClass="textHeaderClassBody" value="#{data.estadoProgramaProduccion.nombreEstadoProgramaProd}" />
                                    </rich:column >
                                    <rich:column  style="width:10%" styleClass="tableCell">
                                        <a4j:commandLink action="#{ManagedSeguimientoProgramaProduccionTouch.seleccionarProgramaProduccionAction}"
                                        oncomplete="window.location.href='navegadorPersonalAcond.jsf'">
                                             <h:graphicImage url="../../img/detalle.jpg" title="Registro de Seguimiento"/>
                                         </a4j:commandLink>
                                    </rich:column>
                                    <%--rich:column  style="width:10%" styleClass="tableCell">
                                        <a4j:commandLink styleClass="outputText2"
                                        onclick="openPopup('seguimientoProcesosEspecificaciones/navegadorDespirogenizado.jsf?codComprod=#{data.formulaMaestra.componentesProd.codCompprod}&codLote=#{data.codLoteProduccion}&codAreaEmpresa=#{data.formulaMaestra.componentesProd.areasEmpresa.codAreaEmpresa}')">
                                             <h:graphicImage url="../../img/detalle.jpg" title="Proceso Despirogenizado"/>
                                         </a4j:commandLink>
                                    </rich:column>
                                 </rich:dataTable--%>
                     </div>
            </section>
                       
                    
                    
                    
                    
             <div  id="formsuper"  style="
                padding: 50px;
                background-color: #cccccc;
                position:absolute;
                z-index: 150;
                left:0px;
                top: 0px;
                border :2px solid #3C8BDA;
                width:100%;
                height:100%;
                filter: alpha(opacity=70);
                visibility:hidden;
                opacity: 0.8;" >

          </div>
                    

            
        </body>
    </html>
    
</f:view>

