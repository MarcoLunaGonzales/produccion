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
    <link rel="STYLESHEET" type="text/css" href="../css/icons.css" />
    <link rel="STYLESHEET" type="text/css" href="../css/chosen.css" /> 
    <script type="text/javascript" src='../js/general.js' ></script>
    <script>
        function validarAgregarMaquinariaActividad()
        {
            if(validarMayorACero(document.getElementById("form3:horasMaquina"))&&validarMayorACero(document.getElementById("form3:horasHombre")))
            {
                return confirm("Esta seguro de realizar la replicación?");
            }
            else
            {
                return false;
            }
            return true;
        }
    </script>
    
</head>
<body>
<a4j:form id="form1"  >                
<div align="center">                    
    <br>
    <h:outputText value="#{ManagedActividadesFormulaMaestra.cargarFormulaMaestra}"/>
    <rich:panel headerClass="headerClassACliente" style="width:80%">
        <f:facet name="header">
            <h:outputText value="Lista de formulas Maestras-Actividad"/>
        </f:facet>
        <h:panelGrid columns="6">
            <h:outputText value="Nombre Producto" styleClass="outputTextBold"/>
            <h:outputText value="::" styleClass="outputTextBold"/>
            <h:inputText style="width:30em" value="#{ManagedActividadesFormulaMaestra.formulaMaestraBuscar.componentesProd.nombreProdSemiterminado}" styleClass="inputText"/>
            <h:outputText value="Tipo Producción" styleClass="outputTextBold"/>
            <h:outputText value="::" styleClass="outputTextBold"/>
            <h:selectOneMenu value="#{ManagedActividadesFormulaMaestra.formulaMaestraBuscar.componentesProd.tipoProduccion.codTipoProduccion}" styleClass="inputText">
                <f:selectItem itemLabel="--TODOS--" itemValue='0'/>
                <f:selectItems value="#{ManagedActividadesFormulaMaestra.tiposProduccionSelectList}"/>
            </h:selectOneMenu>
            <h:outputText value="Estado Producto" styleClass="outputTextBold"/>
            <h:outputText value="::" styleClass="outputTextBold"/>
            <h:selectOneMenu value="#{ManagedActividadesFormulaMaestra.formulaMaestraBuscar.componentesProd.estadoCompProd.codEstadoCompProd}" styleClass="inputText">
                <f:selectItem itemLabel="--TODOS--" itemValue="0"/>
                <f:selectItems value="#{ManagedActividadesFormulaMaestra.estadosCompProdSelectList}"/>
            </h:selectOneMenu>
            <h:outputText value="Area Producción" styleClass="outputTextBold"/>
            <h:outputText value="::" styleClass="outputTextBold"/>
            <h:selectOneMenu value="#{ManagedActividadesFormulaMaestra.formulaMaestraBuscar.componentesProd.areasEmpresa.codAreaEmpresa}" styleClass="inputText">
                <f:selectItem itemLabel="--TODOS--" itemValue="0"/>
                <f:selectItems value="#{ManagedActividadesFormulaMaestra.areasEmpresaSelectList}"/>
            </h:selectOneMenu>
        </h:panelGrid>
        <a4j:commandButton styleClass="btn" value="BUSCAR" action="#{ManagedActividadesFormulaMaestra.buscarFormulaMaestra_action}"
                           reRender="dataFormulaMaestra"/>
    </rich:panel>
    
    <rich:dataTable value="#{ManagedActividadesFormulaMaestra.formulaMaestraList}"
                    var="data" id="dataFormulaMaestra"
                    style="margin-top:1em"
                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                    headerClass="headerClassACliente"
                    columnClasses="tituloCampo">
        <f:facet name="header">
            <rich:columnGroup>
                
                <rich:column>
                    <h:outputText value="Producto"/>
                </rich:column>
                <rich:column>
                    <h:outputText value="Estado Producto"/>
                </rich:column>
                <rich:column>
                    <h:outputText value="Area Empresa"/>
                </rich:column>
                <rich:column>
                    <h:outputText value="Tipo Producción"/>
                </rich:column>
                <rich:column>
                    <h:outputText value="Tamaño Lote"/>
                </rich:column>
                <rich:column>
                    <h:outputText value="Actividades"/>
                </rich:column>
            </rich:columnGroup>
        </f:facet>
        <rich:column>
            <h:outputText value="#{data.componentesProd.nombreProdSemiterminado}"/>
        </rich:column>
        <rich:column>
            <h:outputText value="#{data.componentesProd.estadoCompProd.nombreEstadoCompProd}"/>
        </rich:column>
        <rich:column>
            <h:outputText value="#{data.componentesProd.areasEmpresa.nombreAreaEmpresa}"/>
        </rich:column>
        <rich:column>
            <h:outputText value="#{data.componentesProd.tipoProduccion.nombreTipoProduccion}"/>
        </rich:column>
        <rich:column>
            <h:outputText value="#{data.cantidadLote}"/>
        </rich:column>
        <rich:column>
            <a4j:commandLink oncomplete="redireccionar('navegadorActividadFormulaMaestra.jsf')">
                <f:setPropertyActionListener value="#{data}" target="#{ManagedActividadesFormulaMaestra.formulaMaestraSeleccionada}"/>
                <h:graphicImage url="../img/actividad.jpg"/>
            </a4j:commandLink>
        </rich:column>
    </rich:dataTable>    
    <rich:panel headerClass="headerClassACliente" style="width:80%" rendered="false">
                <f:facet name="header">
                    <h:outputText value="Opciones Generales"/>
                </f:facet>
        <a4j:commandButton value="Agregar Maquinarias"   styleClass="btn"  action="#{ManagedActividadesFormulaMaestra.agregarMaquinariaActividadGeneral_action}"
                             oncomplete="Richfaces.showModalPanel('panelCambioGeneral')" reRender="contenidoCambioGeneral"/>
        <a4j:commandButton value="Inactivar/Activar Actividades"  action="#{ManagedActividadesFormulaMaestra.actividadInactivarActividadGeneral_action}"
                            styleClass="btn"   oncomplete="Richfaces.showModalPanel('panelCambioActividadGeneral')" reRender="contenidoCambioActividadGeneral"/> 
    </rich:panel>
    <div class="barraBotones" id="bottonesAcccion">
        <a4j:commandButton styleClass="btn" value="Agregar Actividad General"  oncomplete="Richfaces.showModalPanel('panelAgregarActividadFormulaMaestraGeneral')"
                           reRender="contenidoAgregarActividadFormulaMaestraGeneral"
                           action="#{ManagedActividadesFormulaMaestra.agregarActividadFormulMaestraGeneral_action}"/>
        <a4j:commandButton styleClass="btn" value="Duplicar Actividades"  onclick="redireccionar('duplicarActividadesFormulaMaestra.jsf')"/>
    </div>
    

</div>
</a4j:form>
<rich:modalPanel id="panelCambioGeneral" minHeight="220"  minWidth="680"
                        height="220" width="680"  zindex="200"
                        headerClass="headerClassACliente"
                        resizeable="true" style="overflow:auto" >
            <f:facet name="header">
                <h:outputText value="Agregar Maquina a una Actividad"/>
            </f:facet>
            <a4j:form id="form3">
                <h:panelGroup id="contenidoCambioGeneral">
                    <h:panelGrid columns="3">
                        <h:outputText styleClass="outputTextBold"  value="Area Fabricacion" />
                        <h:outputText styleClass="outputTextBold"  value="::" />
                        <h:selectOneMenu value="#{ManagedActividadesFormulaMaestra.maquinariaActividadesFormulaAgregarGeneral.actividadesFormulaMaestra.formulaMaestra.componentesProd.areasEmpresa.codAreaEmpresa}" styleClass="inputText" >
                            <f:selectItem itemValue="0" itemLabel="--TODOS--"/>
                            <f:selectItems value="#{ManagedActividadesFormulaMaestra.areasEmpresaSelectList}"  />
                        </h:selectOneMenu>
                        <h:outputText styleClass="outputTextBold"  value="Area Actividad" />
                        <h:outputText styleClass="outputTextBold"  value="::" />
                        <h:selectOneMenu value="#{ManagedActividadesFormulaMaestra.maquinariaActividadesFormulaAgregarGeneral.actividadesFormulaMaestra.areasEmpresa.codAreaEmpresa}" styleClass="inputText" >
                            <f:selectItem itemValue="0" itemLabel="--TODOS--"/>
                            <f:selectItems value="#{ManagedActividadesFormulaMaestra.areasEmpresaActividadSelectList}"  />
                        </h:selectOneMenu>
                        <h:outputText styleClass="outputTextBold"  value="Actividad" />
                        <h:outputText styleClass="outputTextBold"  value="::" />
                        <h:selectOneMenu value="#{ManagedActividadesFormulaMaestra.maquinariaActividadesFormulaAgregarGeneral.actividadesFormulaMaestra.actividadesProduccion.codActividad}"
                        styleClass="inputText"  style="width:300px">
                            <f:selectItems value="#{ManagedActividadesFormulaMaestra.actividadesProduccionSelectList}" />
                        </h:selectOneMenu>
                        <h:outputText styleClass="outputTextBold"  value="Maquinaria" />
                        <h:outputText styleClass="outputTextBold"  value="::" />
                        <h:selectOneMenu value="#{ManagedActividadesFormulaMaestra.maquinariaActividadesFormulaAgregarGeneral.maquinaria.codMaquina}"
                        styleClass="inputText"  >
                            <f:selectItems value="#{ManagedActividadesFormulaMaestra.maquinariasSelectList}" />
                        </h:selectOneMenu>
                        <h:outputText styleClass="outputTextBold"  value="Horas Maquinaria" />
                        <h:outputText styleClass="outputTextBold"  value="::" />
                        <h:inputText onblur="valorPorDefecto(this)" id="horasMaquina" value="#{ManagedActividadesFormulaMaestra.maquinariaActividadesFormulaAgregarGeneral.horasMaquina}" styleClass="inputText"/>
                        <h:outputText styleClass="outputTextBold"  value="Horas Hombre" />
                        <h:outputText styleClass="outputTextBold"  value="::" />
                        <h:inputText onblur="valorPorDefecto(this)" id="horasHombre" value="#{ManagedActividadesFormulaMaestra.maquinariaActividadesFormulaAgregarGeneral.horasHombre}" styleClass="inputText"/>
                    </h:panelGrid>
            </h:panelGroup>
            <br/>
            <div align="center">
                <a4j:commandButton styleClass="btn" value="Guardar"  onclick="if(!validarAgregarMaquinariaActividad()){return false;}"
                                   action="#{ManagedActividadesFormulaMaestra.guardarAgregarMaquinariaActividadGeneral_action}" oncomplete="if(#{ManagedActividadesFormulaMaestra.mensaje eq '1'}){alert('Se agrego la maquina a la actividad');Richfaces.hideModalPanel('panelCambioGeneral');}
                                    else{alert('#{ManagedActividadesFormulaMaestra.mensaje}')}"/>
                 <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelCambioGeneral')" class="btn" />

            </div>


    </a4j:form>
</rich:modalPanel>
            
<rich:modalPanel id="panelCambioActividadGeneral" minHeight="210"  minWidth="420"
                        height="210" width="550"  zindex="200"
                        headerClass="headerClassACliente"
                        resizeable="true" >
                        <f:facet name="header">
                            <h:outputText value="Inactivar/Activar Actividad"/>
                        </f:facet>
                        <a4j:form id="formInactivarActividadGeneral">
                            <h:panelGroup id="contenidoCambioActividadGeneral">
                                <h:panelGrid columns="3">
                                    <h:outputText styleClass="outputTextBold"  value="Area Fabricacion" />
                                    <h:outputText styleClass="outputTextBold"  value="::" />
                                    <h:selectOneMenu value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGeneral.formulaMaestra.componentesProd.areasEmpresa.codAreaEmpresa}" styleClass="inputText" >
                                        <f:selectItem itemLabel="--TODOS--" itemValue="0"/>
                                        <f:selectItems value="#{ManagedActividadesFormulaMaestra.areasEmpresaSelectList}"  />
                                    </h:selectOneMenu>
                                    <h:outputText styleClass="outputTextBold"  value="Area Actividad" />
                                    <h:outputText styleClass="outputTextBold"  value="::" />
                                    <h:selectOneMenu value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGeneral.areasEmpresa.codAreaEmpresa}" styleClass="inputText" style="width:220px">
                                        <f:selectItem itemLabel="--TODOS--" itemValue="0"/>
                                        <f:selectItems value="#{ManagedActividadesFormulaMaestra.areasEmpresaActividadSelectList}"/>
                                    </h:selectOneMenu>
                                    <h:outputText styleClass="outputTextBold"  value="Actividad" />
                                    <h:outputText styleClass="outputTextBold"  value="::" />
                                    <h:selectOneMenu value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraGeneral.actividadesProduccion.codActividad}" styleClass="inputText"  style="width:300px">
                                        <f:selectItems value="#{ManagedActividadesFormulaMaestra.actividadesProduccionSelectList}" />
                                    </h:selectOneMenu>
                                </h:panelGrid>


                        </h:panelGroup>
                        <br/>
                        <div align="center">
                            <a4j:commandButton styleClass="btn" value="Activar"  onclick=" if(confirm('Esta seguro de activar esta actividad?')==false){return false;}"
                                               action="#{ManagedActividadesFormulaMaestra.activarActividadGeneral_action}"
                            oncomplete="if(#{ManagedActividadesFormulaMaestra.mensaje eq '1'}){alert('Se activo la actividad');Richfaces.hideModalPanel('panelCambioActividadGeneral');}else{alert('#{ManagedActividadesFormulaMaestra.mensaje}')}"/>
                            <a4j:commandButton styleClass="btn" value="Inactivar"  onclick=" if(confirm('Esta seguro de inactivar esta actividad?')==false){return false;}"
                                               action="#{ManagedActividadesFormulaMaestra.inactivarActividadGeneral_action}"
                            oncomplete="if(#{ManagedActividadesFormulaMaestra.mensaje eq '1'}){alert('Se inactivo la actividad');Richfaces.hideModalPanel('panelCambioActividadGeneral');}else{alert('#{ManagedActividadesFormulaMaestra.mensaje}')}"/>
                             <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelCambioActividadGeneral')" class="btn" />
                        </div>


                        </a4j:form>
         </rich:modalPanel>
    <a4j:status id="statusPeticion"
                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
    </a4j:status>

    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                     minWidth="200" height="80" width="400" zindex="300" onshow="window.focus();">

        <div align="center">
            <h:graphicImage value="../img/load2.gif" />
        </div>
    </rich:modalPanel>
    <a4j:include id="agregarActividadesGeneral" viewId="agregarActividadesGeneral.jsp"/>
    <a4j:include viewId="../message.jsp" />
    <a4j:loadScript src="../js/chosen.js" />
</body>
</html>

</f:view>

