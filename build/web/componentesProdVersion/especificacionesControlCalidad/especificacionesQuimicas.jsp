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
            function seleccionarRegistro(checked)
            {
                checked.parentNode.parentNode.style.backgroundColor=(checked.checked?'#90EE90':'');
            }
            function retornarNavegador(codTipoModificacionProducto)
            {
                var url="";
                switch(codTipoModificacionProducto)
                {
                    case 1:
                    {
                        url="navegadorNuevosComponentesProd";
                        break;
                    }
                    case 2:
                    {
                        url="navegadorNuevosTamaniosLote";
                        break;
                    }
                    case 3:
                    {
                        url="navegadorComponentesProdVersion";
                        break;
                    }
                    case 4:
                    {
                        url="navegadorNuevosComponentesProd";
                        break;
                    }
                }
                window.location.href="../"+url+".jsf?ef="+(new Date()).getTime().toString();
            }
            </script>
            <style>
               .textBold
               {
                   color:white !important;
                   font-weight:bold;
                   
               }
                .activo
                {
                    background-color:#90EE90;
                }
            </style>
        </head>
        <body >    
            <center>                            
                <a4j:form id="form1"  >
                    <h:outputText value="#{ManagedComponentesProdVersion.cargarEspecificacionesQuimicasProducto}"/>
                  <rich:panel headerClass="headerClassACliente" style="width:60%">
                    <f:facet name="header">
                        <h:outputText value="DATOS DEL PRODUCTO"/>

                    </f:facet>
                     <h:panelGrid columns="3">
                         <h:outputText value="Nro Versión" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.nroVersion}" styleClass="outputText2"/>
                            <h:outputText value="Nombre Producto" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.nombreProdSemiterminado}" styleClass="outputText2"/>
                            <h:outputText value="Nombre Comercial" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.producto.nombreProducto}" styleClass="outputText2"/>
                            
                    </h:panelGrid>

                </rich:panel>
                   <br>
                        <table cellpadding="0" cellspacing="0">
                            <tr><td class="outputTextBold">Habilitado</td><td class="activo" style="width:5em;">&nbsp;</td></tr>
                        </table>
                    <br>
                        <rich:dataTable value="#{ManagedComponentesProdVersion.especificacionesQuimicasProductoList}" var="data" id="dataEspecificacionesQuimicas"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente"  columnClasses="tituloCampo">
                                <rich:subTable value="#{data.listaEspecificacionesQuimicasProducto}"  rowKeyVar="var1"
                                var="subData">
                                    <rich:columnGroup styleClass="headerClassACliente" rendered="#{var1 eq 0}">
                                        <rich:column colspan="5" styleClass="textBold"  >
                                            <h:outputText value="<center>#{data.nombreEspecificacion}</center>" escape="false"/>
                                        </rich:column>
                                        <rich:column breakBefore="true" styleClass="textBold" >
                                            <h:outputText value="Habilitado"  />
                                        </rich:column>
                                        <rich:column styleClass="textBold" >
                                            <h:outputText value="Nombre Material CC"  />
                                        </rich:column>
                                        <rich:column styleClass="textBold" >
                                            <h:outputText value="Nombre Baco"  />
                                        </rich:column>
                                        <rich:column styleClass="textBold" >
                                            <h:outputText value="Especificaciones"  />
                                        </rich:column>
                                        <rich:column styleClass="textBold" >
                                            <h:outputText value="Referencia"  />
                                        </rich:column>
                                    </rich:columnGroup>
                                    <rich:columnGroup style="background-color:#{subData.checked?'#90EE90':''}">
                                        <rich:column>
                                            <h:selectBooleanCheckbox value="#{subData.checked}" onclick="seleccionarRegistro(this);"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{subData.material.nombreCCC}" rendered="#{subData.materialesCompuestosCc.codMaterialCompuestoCc eq '0'}"  />
                                            <h:outputText value="#{subData.materialesCompuestosCc.nombreMaterialCompuestoCc}" rendered="#{subData.materialesCompuestosCc.codMaterialCompuestoCc>0}"  />
                                        </rich:column >
                                         <rich:column>
                                                <h:outputText value="#{subData.material.nombreMaterial}" rendered="#{subData.materialesCompuestosCc.codMaterialCompuestoCc eq '0'}"  />
                                         </rich:column >
                                         <rich:column >
                                            <h:inputText value="#{subData.descripcion}" rendered="#{data.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '1'}" styleClass="inputText"/>
                                            <h:panelGrid columns="3" rendered="#{data.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '2'}">
                                                <h:inputText value="#{subData.limiteInferior}" size="5" onkeypress="valNumero()" styleClass="inputText"/>
                                             <h:outputText value="-" />
                                             <h:inputText value="#{subData.limiteSuperior}" size="5" onkeypress="valNumero()" styleClass="inputText"/>
                                            </h:panelGrid>
                                            <h:panelGrid columns="2" rendered="#{(data.tipoResultadoAnalisis.codTipoResultadoAnalisis != '2') &&(data.tipoResultadoAnalisis.codTipoResultadoAnalisis != '1')}">
                                                <h:outputText value="#{data.coeficiente} #{data.tipoResultadoAnalisis.simbolo}" styleClass="outputText2" />
                                             <h:inputText value="#{subData.valorExacto}" size="5" onkeypress="valNumero()" styleClass="inputText"/>
                                            </h:panelGrid>
                                        </rich:column >
                                        <rich:column >
                                                <h:selectOneMenu value="#{subData.tiposReferenciaCc.codReferenciaCc}" styleClass="inputText">
                                                    <f:selectItems value="#{ManagedComponentesProdVersion.tiposReferenciaCcSelect}"/>
                                                </h:selectOneMenu>
                                         </rich:column>
                                     </rich:columnGroup>
                                </rich:subTable>
                            
                                </rich:dataTable>
                                <br>
                            

                    
                    <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedComponentesProdVersion.guardarEspecificacionesQuimicas_action}"
                                       oncomplete="if(#{ManagedComponentesProdVersion.mensaje eq '1'}){alert('Se registraron las especificaciones quimicas para el producto');retornarNavegador(#{ManagedComponentesProdVersion.componentesProdVersionBean.tiposModificacionProducto.codTipoModificacionProducto});}
                        else{alert('#{ManagedComponentesProdVersion.mensaje}')}" timeout="10000"/>
                    <a4j:commandButton value="Cancelar"  styleClass="btn" oncomplete="retornarNavegador(#{ManagedComponentesProdVersion.componentesProdVersionBean.tiposModificacionProducto.codTipoModificacionProducto});"/>
                    </div>            
                </a4j:form>
                 <rich:modalPanel id="panelMaterialesHabilitados" minHeight="250"  minWidth="250"
                                     height="250" width="250"  zindex="200"  headerClass="headerClassACliente"
                                     resizeable="false" style="overflow:auto" >
                        <f:facet name="header">
                            <h:outputText value="Materiales Activos del Producto"/>
                        </f:facet>
                        <center>
                        <a4j:form id="form2">
                            <rich:dataTable value="#{ManagedEspecificacionesControlCalidad.listaMaterialesPrincipioActivo}" var="datam" id="dataMaterialesPrincipioActivo"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo">
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Material"  />
                            </f:facet>
                            <h:outputText value="#{datam.nombreMaterial}" />
                        </rich:column >
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:selectOneMenu value="#{datam.estadoRegistro.codEstadoRegistro}" styleClass="inputText">
                                <f:selectItem itemValue="1" itemLabel="Activo"/>
                                <f:selectItem itemValue="2" itemLabel="No Activo"/>
                                <f:selectItem itemValue="3" itemLabel="Variado"/>
                            </h:selectOneMenu>
                       </rich:column>
                      </rich:dataTable>
                            
                       <a4j:commandButton styleClass="btn" value="Aceptar"
                       oncomplete="javascript:Richfaces.hideModalPanel('panelMaterialesHabilitados')" action="#{ManagedEspecificacionesControlCalidad.habilitarMaterialesPrincipioActivo}"
                                           reRender="dataEspecificacionesProducto" />
                      <a4j:commandButton styleClass="btn" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelMaterialesHabilitados')"  />
                        </a4j:form>
                        </center>
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
            </center>    
        </body>
    </html>
    
</f:view>

