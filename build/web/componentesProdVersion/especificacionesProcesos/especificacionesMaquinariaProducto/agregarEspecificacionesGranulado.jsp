<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>

    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../../css/ventas.css" />
            <script type="text/javascript" src="../../../js/general.js" ></script>
            <script>

             function vaciar()
             {
                 var var1=document.getElementById('formRegistrar:nombreUnidad');
                 var1.value='';
                 var var2=document.getElementById('formRegistrar:nombreAbrev');
                 var2.value='';
                 var var3=document.getElementById('formRegistrar:obserNuevo');
                 var3.value='';
                 var var4=document.getElementById('formRegistrar:obserNuevo');
                 var4.value='';
                 var var5=document.getElementById('formRegistrar:claveUnidad1');
                 var5.value='0';
                 var var6=document.getElementById('formRegistrar:unidad1');
                 var6.value='4';

             }
            </script>
          
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedEspecificacionesDespirogenizado.cargarEspecificacionesGranuladoMaquina}"/>
                    <h:outputText styleClass="outputText2" style="font-size:13;font-weight:bold" 
                    value="Editar Especificaciones Granulado Maquina" />
                    <br/>
                        <rich:panel headerClass="headerClassACliente" style="width:80%">
                            <f:facet name="header">
                                <h:outputText value="Datos del Producto"/>

                            </f:facet>
                            <h:panelGrid columns="3" headerClass="headerClassACliente">
                                <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedEspecificacionesDespirogenizado.componentesProdBean.nombreProdSemiterminado} " styleClass="outputText2"/>
                               <h:outputText value="Forma farmaceútica" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedEspecificacionesDespirogenizado.componentesProdBean.forma.nombreForma} " styleClass="outputText2"/>
                               <h:outputText value="Area de Fabricación" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedEspecificacionesDespirogenizado.componentesProdBean.areasEmpresa.nombreAreaEmpresa} " styleClass="outputText2"/>
                               <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedEspecificacionesDespirogenizado.componentesProdBean.estadoCompProd.nombreEstadoCompProd} " styleClass="outputText2"/>
                               <h:outputText value="Maquina" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedEspecificacionesDespirogenizado.maquinaTableteado.nombreMaquina} " styleClass="outputText2"/>
                               <h:outputText value="Codigo Máquina" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedEspecificacionesDespirogenizado.maquinaTableteado.codigo} " styleClass="outputText2"/>
                              
                            </h:panelGrid>
                        </rich:panel>

                    <rich:panel headerClass="headerClassACliente" style="width:80%;margin-top:1em !important">
                            <f:facet name="header">
                                <h:outputText value="Asignacion de Receta Lavado"/>

                            </f:facet>
                            
                            <rich:dataTable value="#{ManagedEspecificacionesDespirogenizado.especificacionesGranuladoProdList}"
                                            var="data" id="dataEspecificacionesProceso"
                                            onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                            onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                            headerClass="headerClassACliente"  style="margin-top:12px">
                                <h:column>
                                    <f:facet name="header">
                                        <h:outputText value="Nombre Especificación"  />
                                    </f:facet>
                                    <h:outputText  value="#{data.especificacionesProcesos.nombreEspecificacionProceso}"  />
                                </h:column>
                                <h:column>
                                    <f:facet name="header">
                                        <h:outputText value="Valor"  />
                                    </f:facet>

                                    <h:inputText  value="#{data.valorExacto}" onkeypress="valNum()"  rendered="#{data.especificacionesProcesos.resultadoNumerico}"/>
                                    <h:inputText  value="#{data.valorTexto}"  rendered="#{!data.especificacionesProcesos.resultadoNumerico}"/>
                                </h:column>
                                <h:column>
                                    <f:facet name="header">
                                        <h:outputText value="Tipo de Valor"  />
                                    </f:facet>
                                    <h:outputText  value="Numerico"  rendered="#{data.especificacionesProcesos.resultadoNumerico}"/>
                                    <h:outputText  value="Texto"  rendered="#{!data.especificacionesProcesos.resultadoNumerico}"/>
                                </h:column>

                                <h:column>
                                    <f:facet name="header">
                                        <h:outputText value="Unidad Medida"  />
                                    </f:facet>
                                    <h:outputText value="#{data.especificacionesProcesos.unidadMedida.nombreUnidadMedida}"/>
                                </h:column>
                                <h:column>
                                    <f:facet name="header">
                                        <h:outputText value="Porciento Tolerancia"  />
                                    </f:facet>
                                    <h:outputText value="#{data.especificacionesProcesos.porcientoTolerancia}%" rendered="#{data.especificacionesProcesos.porcientoTolerancia>0}"/>
                                </h:column>

                            </rich:dataTable>
                            </rich:panel>
                           
                             <div style="margin-top:12px">
                                 <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedEspecificacionesDespirogenizado.guardarEspecificacionesGranulado_action}"
                                 oncomplete="if(#{ManagedEspecificacionesDespirogenizado.mensaje eq '1'}){alert('Se registraron la especificaciones de la maquina');
                                 var a=Math.random();window.location.href='navegadorGranuladoMaquinarias.jsf?cod='+a;}else{alert('#{ManagedEspecificacionesDespirogenizado.mensaje}');}"/>
                                 <a4j:commandButton value="Cancelar" styleClass="btn" onclick="var a=Math.random();window.location.href='navegadorGranuladoMaquinarias.jsf?cod='+a;"/>
                            </div>
                      
                     

                   
                </div>

               
              
            </a4j:form>
            
            <a4j:include viewId="/panelProgreso.jsp"/>
            <a4j:include viewId="/message.jsp"/>

        </body>
    </html>

</f:view>

