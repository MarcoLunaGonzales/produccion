asdasdas
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>


<f:view>
    
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src='../js/general.js' ></script>
            <script type="text/javascript" src='../js/treeComponet.js' ></script> 
            <style type="text/css">
                .codcompuestoprod{
                background-color:#ADD797;
                }.nocodcompuestoprod{
                background-color:#FFFFFF;
                }
                
            </style>
            <script type="text/javascript">
                var seleccionado=0;
                function seleccionar(nombreTabla)
                {
                    var tabla=document.getElementById(nombreTabla);
                    var cont=0;
                    for(var i=1;i<tabla.rows.length;i++)
                    {
                        if(tabla.rows[i].cells[0].getElementsByTagName('input')[0]!=null && tabla.rows[i].cells[0].getElementsByTagName('input')[0].checked)
                        {
                            cont++;
                            seleccionado=tabla.rows[i].cells[1].getElementsByTagName('input')[0].value;
                        }
                    }
                    if(cont==0)
                     {
                        alert('Debe seleccionar al menos un registro');
                        return false;
                     }
                    return true;
                }
                function openPopup(url){
                       window.open(url,'detalle'+Math.round((Math.random()*1000)),'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
                }
                function registrarControlDeCambios(codFormulaMaestraVersion,codCompProdVersion)
                {
                    urlOOS="../controlDeCambios/registroControlCambios.jsf?codFormulaMaestraVersion="+codFormulaMaestraVersion+
                        "&codCompProdVersion="+codCompProdVersion+"&date="+(new Date()).getTime().toString()+"&ale="+Math.random();
                    window.open(urlOOS,'detalle'+Math.round((Math.random()*1000)),'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');

                }
                function registrarControlCambios()
                {
                    registrarControlDeCambios(0,seleccionado);
                }
                    </script>
        </head>
        <body>
            
            <h:form id="form1"  >                
                <div align="center">                    
                    
                    <h:outputText value="#{ManagedComponentesProducto.cargarVersionesCompProd}"   />
                    <h3>Versiones de Producto Semiterminado</h3>
                    
                    
                    <br>    <br>
                    
                    <br><br>

                        <rich:panel headerClass="headerClassACliente">
                            <f:facet name="header">
                                <h:outputText value="Datos de Producto Semiterminado" />
                            </f:facet>
                            <h:panelGrid columns="6" styleClass="outputText2">
                                <h:outputText value="Producto Semiterminado:" style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.nombreProdSemiterminado}"  />
                                <h:outputText value="Forma Farmaceutica:"  style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.forma.nombreForma}"  />
                                <h:outputText value="Via Administracion:" style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.viasAdministracionProducto.nombreViaAdministracionProducto}"  />
                                <h:outputText value="Volumen Envase Primario:" style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.cantidadVolumen}"  />
                                <h:outputText value="Tolerancia Volumen a fabricar:" style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.toleranciaVolumenfabricar}"  />
                                <h:outputText value="Concentracion Envase Primario:" style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.concentracionEnvasePrimario}"  />
                                <h:outputText value="Peso envase primario:" style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.pesoEnvasePrimario}"  />
                                <h:outputText value="Color Presentacion Primaria:" style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.coloresPresentacion.nombreColor}"  />
                                <h:outputText value="Sabor:"  style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.saboresProductos.nombreSabor}"  />
                                <h:outputText value="Area Fabricacion:" style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.areasEmpresa.nombreAreaEmpresa}"  />
                                <h:outputText value="Nombre Generico:" style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.nombreGenerico}"  />
                                <h:outputText value="Reg. Sanitario:" style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.regSanitario}"  />
                                <h:outputText value="Fecha Vencimiento R.S.:"  style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.fechaVencimientoRS}">
                                    <f:convertDateTime pattern="dd/MM/yyyy" />
                                </h:outputText>
                                <h:outputText value="Vida Util:" style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.vidaUtil}"  />
                                <h:outputText value="Estado:" style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.estadoCompProd.nombreEstadoCompProd}"  />
                            
                        
                            </h:panelGrid>
                        </rich:panel>
                    <rich:dataTable value="#{ManagedComponentesProducto.componentesProdVersionesList}" var="data" id="dataProductosVersion"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';" 
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo"
                                    binding = "#{ManagedComponentesProducto.componentesProdVersionDataTable}"
                                    >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            
                            <h:selectBooleanCheckbox value="#{data.checked}" rendered="#{data.estadosVersion.codEstadoVersion=='4' || data.estadosVersion.codEstadoVersion=='5'}"  />
                            
                        </rich:column>
                        
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Nombre Producto Semiterminado"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreProdSemiterminado}"  />
                            <h:inputHidden value="#{data.codVersion}"/>
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Nro Version"  />
                            </f:facet>
                            <h:outputText value="#{data.nroVersion}"  />
                        </rich:column >
                        
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Forma Farmacéutica"  />
                            </f:facet>
                            <h:outputText value="#{data.forma.nombreForma}"  />
                        </rich:column >
                        
                        
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Via Administración"  />
                            </f:facet>
                            <h:outputText value="#{data.viasAdministracionProducto.nombreViaAdministracionProducto}"  />
                        </rich:column >
                        
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Volúmen Envase Primario "  />
                            </f:facet>
                            <h:outputText value="#{data.cantidadVolumen}" rendered="#{data.cantidadVolumen>0}">
                                <f:convertNumber pattern="###.##" locale="EN" />
                            </h:outputText>
                            <h:outputText value=" #{data.unidadMedidaVolumen.abreviatura}" rendered="#{data.cantidadVolumen>0}"/>
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Tolerancia Volumen a Fabricar"  />
                            </f:facet>
                            <h:outputText value="#{data.toleranciaVolumenfabricar}" rendered="#{data.toleranciaVolumenfabricar>0}" />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Concentración Envase Primario "  />
                            </f:facet>
                            <h:outputText value="#{data.concentracionEnvasePrimario}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Peso Envase Primario "  />
                            </f:facet>
                            <h:outputText value="#{data.pesoEnvasePrimario}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Color Presentación Primaria"  />
                            </f:facet>
                            <h:outputText value="#{data.coloresPresentacion.nombreColor}"  />
                        </rich:column >
                        
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Sabor"  />
                            </f:facet>
                            <h:outputText value="#{data.saboresProductos.nombreSabor}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Área de Fabricación"  />
                            </f:facet>
                            <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Nombre Generico"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreGenerico}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Reg. Sanitario"  />
                            </f:facet>
                            <h:outputText value="#{data.regSanitario}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Fecha Emisión R.S."  />
                            </f:facet>
                            <h:outputText value="#{data.fechaVencimientoRS}"  >
                                <%--f:convertDateTime pattern="dd/MM/yyyy"   /--%>
                            </h:outputText>
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Vida Util"  />
                            </f:facet>
                            <h:outputText value="#{data.vidaUtil}"  />
                        </rich:column >
                        
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadosVersion.nombreEstadoVersion}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Tipo Producción"  />
                            </f:facet>
                            <h:outputText value="#{data.tipoProduccion.nombreTipoProduccion}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Fecha Modificacion"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaModificacion}"  >
                                <f:convertDateTime pattern="dd/MM/yyyy hh:MM:ss" />
                            </h:outputText>
                        </rich:column >
                        
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Personal Creacion"  />
                            </f:facet>
                            <h:outputText value="#{data.personaCreacion.nombrePersonal}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Tipo Modificacion"  />
                            </f:facet>
                            <h:outputText value="#{data.tiposModificacionProducto.nombreTipoModificacionProducto}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Fecha Inicio Vigencia"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaInicioVigencia}"  >
                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm:ss" />
                            </h:outputText>
                        </rich:column >
                        
                        <%--rich:column styleClass="#{data.columnStyle}"  >
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>

                            <a4j:commandLink  onclick="location='navegadorPresentacionesPrimariasVersion.jsf?codigo=#{data.codCompprod}&codVersion=#{data.codVersion}'" >
                                <h:graphicImage url="../img/organigrama3.jpg"  alt="Etiquetas" />
                            </a4j:commandLink>
                            
                            
                        </rich:column--%>
                        <%--rich:column styleClass="#{data.columnStyle}"  >
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:commandLink styleClass="outputText2" action="#{ManagedComponentesProducto.editarPresentacionesSecundarias_actionVersion}"
                             value="Presentaciones Secundarias" rendered="#{data.estadosVersion.codEstadoVersion=='4' || data.estadosVersion.codEstadoVersion=='5'}" />
                            
                        </rich:column--%>
                        
                        <rich:column styleClass="#{data.columnStyle}"  ><%--  rendered="#{ManagedComponentesProducto.opcionPresPrim}" --%>
                            <f:facet name="header">
                                <h:outputText value="EP"  />
                            </f:facet>
                             <a4j:commandLink  onclick="location='navegadorPresentacionesPrimariasVersion.jsf?codigo=#{data.codCompprod}&codVersion=#{data.codVersion}&direccion=navegador_componentesProductoVersion.jsf'" >
                                <h:graphicImage url="../img/organigrama3.jpg"  alt="Etiquetas" />
                            </a4j:commandLink>
                        </rich:column>
                        
                        <rich:column styleClass="#{data.columnStyle}"  > <%-- rendered="#{ManagedComponentesProducto.opcionPresSecun}" --%>
                            <f:facet name="header">
                                <h:outputText value="ES"  />
                            </f:facet>
                            <a4j:commandLink  action="#{ManagedComponentesProducto.editarPresentacionesSecundarias_actionVersion}" >
                                <f:param name="direccion" value="navegador_componentesProductoVersion.jsf" />
                                <h:graphicImage url="../img/organigrama3.jpg"  alt="Etiquetas" />
                            </a4j:commandLink>
                        </rich:column>

                    </rich:dataTable>
                    <br>
                    <a4j:commandButton  rendered="#{ManagedComponentesProducto.agregarEdicionProd}" styleClass="btn"  value="Registrar" action="#{ManagedComponentesProducto.registrarComponentesProdVersion_action}" onclick="if(confirm('esta seguro de registrar nueva version?')==false){return false;}"reRender="dataProductosVersion" />
                    <a4j:commandButton  rendered="#{ManagedComponentesProducto.agregarEdicionProd}" styleClass="btn"  value="Solicitar Aprobacion" onclick=" if(seleccionar('form1:dataProductosVersion')==false){return false;};if(confirm('esta seguro de solicitar?')==false){return false;}" action="#{ManagedComponentesProducto.solicitarAprobacionVersion_action}" reRender="dataProductosVersion" oncomplete="registrarControlCambios();" />
                    <a4j:commandButton rendered="#{ManagedComponentesProducto.agregarEdicionProd}" value="Editar"  styleClass="btn"  action="#{ManagedComponentesProducto.actionEditarVersion}" oncomplete = "location = 'modificar_componentesProductoVersion.jsf'"  >
                        <f:param name="direccion" value="navegador_componentesProductoVersion.jsf" />
                    </a4j:commandButton><%-- onclick="return editarItem('form1:dataProductosVersion');" --%>
                    <h:commandButton rendered="#{ManagedComponentesProducto.editarRs}" value="Editar R.S."  styleClass="btn"  action="#{ManagedComponentesProducto.editarRegistroSanitarioVersion_action}" onclick="return editarItem('form1:dataProductosVersion');"/>
                    <h:commandButton rendered="#{ManagedComponentesProducto.editarTipoProd}" value="Editar Produccion"  styleClass="btn" style="width='150px'" action="#{ManagedComponentesProducto.editarTipoProduccion_action}" onclick="return editarItem('form1:dataProductosVersion');"/>
                    <a4j:commandButton rendered="#{ManagedComponentesProducto.agregarEdicionProd}" value="Eliminar" onclick=" if(confirm('esta seguro de eliminar?')==false){return false;} if(seleccionar('form1:dataProductosVersion')==false){return false;} "   styleClass="btn"  action="#{ManagedComponentesProducto.eliminarComponenteProdVersion_action}" oncomplete="location='navegador_componentesProductoVersion.jsf'" />
                    <a4j:commandButton value="Cancelar"  styleClass="btn" onclick="location='navegador_componentesProducto.jsf'"  />
                    
                    
                </div>
                <!--cerrando la conexion-->
               
            </h:form>
            
            
        </body>
    </html>
    
</f:view>

