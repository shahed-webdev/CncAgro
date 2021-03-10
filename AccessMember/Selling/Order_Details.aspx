<%@ Page Title="Order Details" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="Order_Details.aspx.cs" Inherits="CncAgro.AccessMember.Selling.Order_Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Order Details</h3>
    <a href="Order_Record.aspx"><i class="far fa-hand-point-left"></i>
        Back To Record</a>
    <asp:FormView ID="MemberFormView" runat="server" DataSourceID="OrderInfoSQL" Width="100%" DataKeyNames="Product_DistributionID">
        <EditItemTemplate>
            Name:
                    <asp:TextBox ID="NameTextBox" runat="server" Text='<%# Bind("Name") %>' />
            <br />
            UserName:
                    <asp:TextBox ID="UserNameTextBox" runat="server" Text='<%# Bind("UserName") %>' />
            <br />
            Phone:
                    <asp:TextBox ID="PhoneTextBox" runat="server" Text='<%# Bind("Phone") %>' />
            <br />
            ServedBy:
                    <asp:TextBox ID="ServedByTextBox" runat="server" Text='<%# Bind("ServedBy") %>' />
            <br />
            Product_Total_Amount:
                    <asp:TextBox ID="Product_Total_AmountTextBox" runat="server" Text='<%# Bind("Product_Total_Amount") %>' />
            <br />
            Distribution_SN:
                    <asp:TextBox ID="Distribution_SNTextBox" runat="server" Text='<%# Bind("Distribution_SN") %>' />
            <br />
            Is_Confirmed:
                    <asp:CheckBox ID="Is_ConfirmedCheckBox" runat="server" Checked='<%# Bind("Is_Confirmed") %>' />
            <br />
            Is_Delivered:
                    <asp:CheckBox ID="Is_DeliveredCheckBox" runat="server" Checked='<%# Bind("Is_Delivered") %>' />
            <br />
            Delivery_Date:
                    <asp:TextBox ID="Delivery_DateTextBox" runat="server" Text='<%# Bind("Delivery_Date") %>' />
            <br />
            Confirm_Date:
                    <asp:TextBox ID="Confirm_DateTextBox" runat="server" Text='<%# Bind("Confirm_Date") %>' />
            <br />
            InsertDate:
                    <asp:TextBox ID="InsertDateTextBox" runat="server" Text='<%# Bind("InsertDate") %>' />
            <br />
            MemberID:
                    <asp:TextBox ID="MemberIDTextBox" runat="server" Text='<%# Bind("MemberID") %>' />
            <br />
            Product_DistributionID:
                    <asp:Label ID="Product_DistributionIDLabel1" runat="server" Text='<%# Eval("Product_DistributionID") %>' />
            <br />
            <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" Text="Update" />
            &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
        </EditItemTemplate>
        <InsertItemTemplate>
            Name:
                    <asp:TextBox ID="NameTextBox" runat="server" Text='<%# Bind("Name") %>' />
            <br />
            UserName:
                    <asp:TextBox ID="UserNameTextBox" runat="server" Text='<%# Bind("UserName") %>' />
            <br />
            Phone:
                    <asp:TextBox ID="PhoneTextBox" runat="server" Text='<%# Bind("Phone") %>' />
            <br />
            ServedBy:
                    <asp:TextBox ID="ServedByTextBox" runat="server" Text='<%# Bind("ServedBy") %>' />
            <br />
            Product_Total_Amount:
                    <asp:TextBox ID="Product_Total_AmountTextBox" runat="server" Text='<%# Bind("Product_Total_Amount") %>' />
            <br />
            Distribution_SN:
                    <asp:TextBox ID="Distribution_SNTextBox" runat="server" Text='<%# Bind("Distribution_SN") %>' />
            <br />
            Is_Confirmed:
                    <asp:CheckBox ID="Is_ConfirmedCheckBox" runat="server" Checked='<%# Bind("Is_Confirmed") %>' />
            <br />
            Is_Delivered:
                    <asp:CheckBox ID="Is_DeliveredCheckBox" runat="server" Checked='<%# Bind("Is_Delivered") %>' />
            <br />
            Delivery_Date:
                    <asp:TextBox ID="Delivery_DateTextBox" runat="server" Text='<%# Bind("Delivery_Date") %>' />
            <br />
            Confirm_Date:
                    <asp:TextBox ID="Confirm_DateTextBox" runat="server" Text='<%# Bind("Confirm_Date") %>' />
            <br />
            InsertDate:
                    <asp:TextBox ID="InsertDateTextBox" runat="server" Text='<%# Bind("InsertDate") %>' />
            <br />
            MemberID:
                    <asp:TextBox ID="MemberIDTextBox" runat="server" Text='<%# Bind("MemberID") %>' />
            <br />
            <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" Text="Insert" />
            &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
        </InsertItemTemplate>
        <ItemTemplate>
            Name:
                <asp:Label ID="NameLabel" runat="server" Text='<%# Bind("Name") %>' />
            <br />
            UserName:
                <asp:Label ID="UserNameLabel" runat="server" Text='<%# Bind("UserName") %>' />
            <br />
            Phone:
                <asp:Label ID="PhoneLabel" runat="server" Text='<%# Bind("Phone") %>' />
            <br />
            ServedBy:
                <asp:Label ID="ServedByLabel" runat="server" Text='<%# Bind("ServedBy") %>' />
            <br />
            Product_Total_Amount:
                <asp:Label ID="Product_Total_AmountLabel" runat="server" Text='<%# Bind("Product_Total_Amount") %>' />
            <br />
            Distribution_SN:
                <asp:Label ID="Distribution_SNLabel" runat="server" Text='<%# Bind("Distribution_SN") %>' />
            <br />
            Is_Confirmed:
                <asp:CheckBox ID="Is_ConfirmedCheckBox" runat="server" Checked='<%# Bind("Is_Confirmed") %>' Enabled="false" />
            <br />
            Is_Delivered:
                <asp:CheckBox ID="Is_DeliveredCheckBox" runat="server" Checked='<%# Bind("Is_Delivered") %>' Enabled="false" />
            <br />
            Delivery_Date:
                <asp:Label ID="Delivery_DateLabel" runat="server" Text='<%# Bind("Delivery_Date") %>' />
            <br />
            Confirm_Date:
                <asp:Label ID="Confirm_DateLabel" runat="server" Text='<%# Bind("Confirm_Date") %>' />
            <br />
            InsertDate:
                <asp:Label ID="InsertDateLabel" runat="server" Text='<%# Bind("InsertDate") %>' />
            <br />
            MemberID:
                <asp:Label ID="MemberIDLabel" runat="server" Text='<%# Bind("MemberID") %>' />
            <br />
            Product_DistributionID:
                <asp:Label ID="Product_DistributionIDLabel" runat="server" Text='<%# Eval("Product_DistributionID") %>' />
            <br />
        </ItemTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="OrderInfoSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.Name, Registration.UserName, Registration.Phone, Registration_1.Name AS ServedBy, Product_Distribution.Product_Total_Amount, Product_Distribution.Distribution_SN, Product_Distribution.Is_Confirmed, Product_Distribution.Is_Delivered, Product_Distribution.Delivery_Date, Product_Distribution.Confirm_Date, Product_Distribution.InsertDate, Product_Distribution.MemberID, Product_Distribution.Product_DistributionID FROM Product_Distribution INNER JOIN Registration INNER JOIN Member ON Registration.RegistrationID = Member.MemberRegistrationID ON Product_Distribution.MemberID = Member.MemberID INNER JOIN Registration AS Registration_1 ON Product_Distribution.Admin_RegistrationID = Registration_1.RegistrationID"></asp:SqlDataSource>
   
    <div class="table-responsive">
        <asp:GridView ID="DetailsGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="DetailsSQL">
            <Columns>
                <asp:BoundField DataField="Product_Code" HeaderText="Code" SortExpression="Product_Code" />
                <asp:BoundField DataField="Product_Name" HeaderText="Product Name" SortExpression="Product_Name" />
                <asp:BoundField DataField="SellingQuantity" HeaderText="Quantity" SortExpression="SellingQuantity" />
                <asp:BoundField DataField="SellingUnitPrice" HeaderText="Unit Price" SortExpression="SellingUnitPrice" />
                <asp:BoundField DataField="ProductPrice" HeaderText="Total Price" ReadOnly="True" SortExpression="ProductPrice" />
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="DetailsSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Product_Point_Code.Product_Code, Product_Point_Code.Product_Name, Product_Distribution_Records.SellingQuantity, Product_Distribution_Records.SellingUnitPrice, Product_Distribution_Records.SellingUnitPoint, Product_Distribution_Records.ProductPrice, Product_Distribution_Records.TotalPoint FROM Product_Distribution_Records INNER JOIN Product_Point_Code ON Product_Distribution_Records.ProductID = Product_Point_Code.Product_PointID WHERE (Product_Distribution_Records.Product_DistributionID = @Product_DistributionID)">
            <SelectParameters>
                <asp:QueryStringParameter Name="Product_DistributionID" QueryStringField="id" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>
