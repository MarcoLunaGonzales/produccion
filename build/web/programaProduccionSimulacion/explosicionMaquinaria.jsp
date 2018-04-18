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
<script type="text/javascript" src="../js/general.js" ></script> 

<body >
    <div  align="center" id="panelCenter">
        <a4j:form id="form1"  >               
        <h:outputText styleClass="outputTextTitulo"  value="Explosión de Horas en Maquinaria y Mano de Obra" />                    
        <br/>
        <rich:dataTable value="#{ManagedProgramaProduccionSimulacion.explotacionMaquinariasLista}" var="data"  
                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                        onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                        headerClass="headerClassACliente" >
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Maquinaria"  />
                </f:facet>
                <h:outputText value="#{data[0]}"  />
            </h:column>
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Horas Máquina"  />
                </f:facet>
                <h:outputText value="#{data[1]}"  />
            </h:column>     
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Horas Hombre "  />
                </f:facet>
                <h:outputText value="#{data[2]}"  />
            </h:column>
            
            <f:facet name="footer">
                <rich:columnGroup>
                   <rich:column colspan="1">
                       <h:outputText value="Total"  />
                   </rich:column>
                   <rich:column>
                       <h:outputText value="#{ManagedProgramaProduccionSimulacion.hrs_maquina}" />                                                    
                   </rich:column> 
                   <rich:column>
                       <h:outputText value="#{ManagedProgramaProduccionSimulacion.hrs_hombre}" />
                   </rich:column> 
                </rich:columnGroup>
            </f:facet> 
        </rich:dataTable>
        
        <br/> <br/>  <br/> 
        
        <rich:dataTable value="#{ManagedProgramaProduccionSimulacion.programaProduccionList}" var="data" id="dataFormula" 
                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                        onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                        headerClass="headerClassACliente" >
            <h:column rendered="#{data.checked}">
                <f:facet name="header">
                    <h:outputText value="Producto"  />
                </f:facet>
                <h:outputText value="#{data.formulaMaestra.componentesProd.nombreProdSemiterminado}"  />
            </h:column>
            <h:column rendered="#{data.checked}">
                <f:facet name="header">
                    <h:outputText value="Lote"  />
                </f:facet>
                <h:outputText value="#{data.formulaMaestra.cantidadLote}"  />
            </h:column>
            <h:column rendered="#{data.checked}">
                <f:facet name="header">
                    <h:outputText value="Nro. de Lotes a Producir"  />
                </f:facet>
                <h:outputText value="#{data.cantidadLote}"  />
            </h:column>
            <h:column rendered="#{data.checked}">
                <f:facet name="header">
                    <h:outputText value="Total de Lotes a Producir"  />
                </f:facet>
                <h:outputText value="#{data.totalLote}"  />
            </h:column>
        </rich:dataTable>
        <div align="center" style="" id="botones"  >
            <h:commandButton value="Aceptar"   styleClass="btn"  onclick="location='navegador_programa_produccion.jsf?codProgramaProd='+#{ManagedProgramaProduccionSimulacion.programaProduccionbean.codProgramaProduccion} "  type="button"/>
        </div>
    </div>
    </a4j:form>
</body>
</html>

</f:view>

