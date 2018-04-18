<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js"></script>
             <style type="text/css">
                .versionActiva{
                    background-color:#90EE90
                }
            </style>
            <script>
                A4J.AJAX.onError = function(req,status,message){
            window.alert("Ocurrio un error: "+message);
            }
            A4J.AJAX.onExpired = function(loc,expiredMsg){
            if(window.confirm("Ocurrio un error al momento realizar la transaccion: "+expiredMsg+" location: "+loc)){
            return loc;
            } else {
            return false;
            }
            }
            function valNumero()
            {
                if ((event.keyCode < 48 || event.keyCode > 57)&& event.keyCode!=46)
                 {
                    alert('Introduzca sólo Números');
                    event.returnValue = false;
                 }
                 
            }
            
             function verificarAutorizacion()
            {
                var cod=document.getElementById("formRegistrar:codigo").innerHTML;
                var var1=cod.substring(0,1);
                var var2=cod.substring(cod.length-1,cod.length);
                var sum=0;
                for(var cont=0;cont<=cod.length-1;cont++)
                {
                    sum+=parseInt(cod.substring(cont, cont+1));
                }
                var cod=sum+var2+var1;
                if(cod==document.getElementById("formRegistrar:autorizacion").value)
                {

                    window.location.href='editarVersionEspecificacionesMicro.jsf?cod='+cod+"&al="+Math.random();
                }
                else
                {
                    alert('Autorización invalida');
                }
            }
            function verificarAutorizacionActivar()
            {
                var cod=document.getElementById("formEliminar:codigo").innerHTML;
                var var1=cod.substring(0,1);
                var var2=cod.substring(cod.length-1,cod.length);
                var sum=0;
                for(var cont=0;cont<=cod.length-1;cont++)
                {
                    sum+=parseInt(cod.substring(cont, cont+1));
                }
                var cod=sum+var2+var1;
                if(cod==document.getElementById("formEliminar:autorizacion").value)
                {
                    return true;
                }
                alert('Autorización invalida');
                return false;

            }
            function verificarAccionRegistro(nametable){
               var count=0;
               var tabla=document.getElementById(nametable);
               for(var i=2;i<tabla.rows.length;i++)
               {
                   if(tabla.rows[i].cells[0].getElementsByTagName('input')[0].checked)
                   {
                       count++;
                   }
               }
               if(count==1){
                  return true;
               } else if(count==0){
                   alert('No escogio ningun registro');
                   return false;
               }
               else if(count>1){
                   alert('Solo puede escoger un registro');
                   return false;
               }
            }
            
            </script>
        </head>
        <body >    
            <div style="text-align:center">
                <h:form id="form1"  >
                <h:outputText value="#{ManagedEspecificacionesControlCalidad.cargarVersionesMicrobiologicasProducto}"/>
                <rich:panel headerClass="headerClassACliente" style="width:60%">
                    <f:facet name="header">
                        <h:outputText value="DATOS DEL PRODUCTO"/>

                    </f:facet>
                    <h:panelGrid columns="3" headerClass="headerClassACliente">
                        <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                       <h:outputText value=" : " styleClass="outputText2" style="font-weight:bold"/>
                       <h:outputText value="#{ManagedEspecificacionesControlCalidad.componentesProd.nombreProdSemiterminado}   " styleClass="outputText2"/>
                        <h:outputText value="Forma Farmaceútica" styleClass="outputText2" style="font-weight:bold"/>
                       <h:outputText value=" : " styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="#{ManagedEspecificacionesControlCalidad.componentesProd.forma.nombreForma}" styleClass="outputText2"/>
                        <h:outputText value="Area de Fabricación" styleClass="outputText2" style="font-weight:bold"/>
                       <h:outputText value=" : " styleClass="outputText2" style="font-weight:bold"/>
                       <h:outputText value="#{ManagedEspecificacionesControlCalidad.componentesProd.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2"/>
                       <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold"/>
                       <h:outputText value=" : " styleClass="outputText2" style="font-weight:bold"/>
                       <h:outputText value="#{ManagedEspecificacionesControlCalidad.componentesProd.estadoCompProd.nombreEstadoCompProd}" styleClass="outputText2"/>
                    </h:panelGrid>
                </rich:panel>
                <br>
                     <table  cellpadding="0" cellspacing="0" style="margin-bottom:8px;">
                        <tr><td ><span style="font-weight:bold" class="outputText2">Version Activa :: </span></td><td class="versionActiva" style="width:30px;"></td></tr>
                    </table>
                
                    <rich:dataTable value="#{ManagedEspecificacionesControlCalidad.versionEspecificacionesProductoList}" var="data" id="dataVersionesFisicas"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column colspan="7" >
                                    <h:outputText value="Versiones Especificaciones Microbiologicas" style='font-weight:bold;font-size:14px' />
                                </rich:column>
                                <rich:column breakBefore="true">
                                    <h:outputText value=""  />
                                </rich:column>
                                 <rich:column>
                                    <h:outputText value="Nro version"  />
                                </rich:column>
                                 <rich:column>
                                    <h:outputText value="Fecha Cargado"  />
                                </rich:column>
                                 <rich:column>
                                    <h:outputText value="Observacion"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Version Activa"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Personal Registra"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Personal Ult. Modificacion"  />
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                         <rich:column styleClass="#{data.versionActiva?'versionActiva':''}">
                            
                            <h:selectBooleanCheckbox value="#{data.checked}"  />

                        </rich:column >
                        <rich:column styleClass="#{data.versionActiva?'versionActiva':''}">
                            <h:outputText value="#{data.nroVersionEspecificacionProducto}" styleClass="outputText2" />
                        </rich:column >
                        <rich:column styleClass="#{data.versionActiva?'versionActiva':''}">
                            <h:outputText value="#{data.fechaCreacion}" styleClass="outputText2">
                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                            </h:outputText>
                        </rich:column >
                        <rich:column styleClass="#{data.versionActiva?'versionActiva':''}">
                            <h:outputText value="#{data.observacion}" styleClass="outputText2" />
                        </rich:column >
                         <rich:column styleClass="#{data.versionActiva?'versionActiva':''}">
                             <h:outputText value="SI" rendered="#{data.versionActiva}"/>
                             <h:outputText value="NO" rendered="#{!data.versionActiva}"/>
                        </rich:column >
                        <rich:column styleClass="#{data.versionActiva?'versionActiva':''}">
                            <h:outputText value="#{data.personalRegistra.nombrePersonal}" styleClass="outputText2" />
                        </rich:column >
                        <rich:column styleClass="#{data.versionActiva?'versionActiva':''}">
                            <h:outputText value="#{data.personalModifica.nombrePersonal}" styleClass="outputText2" />
                        </rich:column >
                   </rich:dataTable>

                <div style="margin-top:12px;">
                    <a4j:commandButton  value="Agregar" action="#{ManagedEspecificacionesControlCalidad.agregarNuevaVersionMicrobiologica_action}" styleClass="btn"/>
                    <a4j:commandButton action="#{ManagedEspecificacionesControlCalidad.editarVersionEspecificacionMicroProducto_action}" value="Editar Version" styleClass="btn"
                    onclick="if(!verificarAccionRegistro('form1:dataVersionesFisicas')){return false;}" oncomplete="Richfaces.showModalPanel('panelAutorizacion');" reRender="contenidoAutorizacion"/>
                    <a4j:commandButton styleClass="btn" onclick="if(!verificarAccionRegistro('form1:dataVersionesFisicas')){return false;}" value="Activar Version"
                    action="#{ManagedEspecificacionesControlCalidad.generarNumeroAleatorio_action}" oncomplete="Richfaces.showModalPanel('panelAutorizacionElimnar');"
                     reRender="contenidoAutorizacionEliminar"/>
                     <a4j:commandButton value="Volver" oncomplete="var a=Math.random();window.location.href='navegador_componentesProducto.jsf?a='+a;" styleClass="btn"/>
                </div>
                    </div>            
                </h:form>


                <rich:modalPanel id="panelAutorizacion" minHeight="140"  minWidth="370"
                                             height="140" width="370"
                                             zindex="200"
                                             headerClass="headerClassACliente"
                                             resizeable="false" style="overflow :auto" >
                                <f:facet name="header">
                                    <h:outputText value="Autorizacion para Edicion de Certificados Aprobados"/>
                                </f:facet>
                                <a4j:form id="formRegistrar">
                                    <center>
                                <h:panelGroup id="contenidoAutorizacion">
                                    <h:panelGrid columns="3">
                                        <h:outputText value="Codigo" styleClass="outputText2" style="font-weight:bold" />
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="#{ManagedEspecificacionesControlCalidad.codigoAleatorio}" styleClass="outputText2" style="font-weight:bold" id="codigo"/>
                                        <h:outputText value="Autorización" styleClass="outputText2" style="font-weight:bold" />
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:inputText value="#{ManagedEspecificacionesControlCalidad.autorizacion}" styleClass="inputText" id="autorizacion"/>

                                    </h:panelGrid>

                                            <input type="button" value="Aceptar" onclick="verificarAutorizacion();" class="btn" />
                                            <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelAutorizacion');" class="btn" />
                                        </center>
                                </h:panelGroup>
                                </a4j:form>
                </rich:modalPanel>

                <rich:modalPanel id="panelAutorizacionElimnar" minHeight="140"  minWidth="370"
                                             height="140" width="370"
                                             zindex="200"
                                             headerClass="headerClassACliente"
                                             resizeable="false" style="overflow :auto" >
                                <f:facet name="header">
                                    <h:outputText value="Autorizacion para Edicion de Certificados Aprobados"/>
                                </f:facet>
                                <a4j:form id="formEliminar">
                                    <center>
                                <h:panelGroup id="contenidoAutorizacionEliminar">
                                    <h:panelGrid columns="3">
                                        <h:outputText value="Codigo" styleClass="outputText2" style="font-weight:bold" />
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="#{ManagedEspecificacionesControlCalidad.codigoAleatorio}" styleClass="outputText2" style="font-weight:bold" id="codigo"/>
                                        <h:outputText value="Autorización" styleClass="outputText2" style="font-weight:bold" />
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:inputText value="#{ManagedEspecificacionesControlCalidad.autorizacion}" styleClass="inputText" id="autorizacion"/>

                                    </h:panelGrid>
                                    <a4j:commandButton styleClass="btn" onclick="if(!verificarAutorizacionActivar()){return false;}" value="Activar Version" action="#{ManagedEspecificacionesControlCalidad.activarVersionEspecificacionMicrobiologiaProducto_ation}"
                                            oncomplete="if(#{ManagedEspecificacionesControlCalidad.mensaje eq '1'}){alert('Se activo la version');javascript:Richfaces.hideModalPanel('panelAutorizacionElimnar');}else{alert('#{ManagedEspecificacionesControlCalidad.mensaje}')}"
                                            reRender="dataVersionesFisicas"/>

                                            <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelAutorizacionElimnar');" class="btn" />
                                        </center>
                                </h:panelGroup>
                                </a4j:form>
                </rich:modalPanel>


                <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                    </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../../img/load2.gif" />
                        </div>
                    </rich:modalPanel>

            </div>    
        </body>
    </html>
    
</f:view>

