<%@ Page Title="Genealogical Tree" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="Member_Binarytree.aspx.cs" Inherits="CncAgro.AccessMember.Member_Binarytree" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/BinaryTree.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Genealogical Tree</h3>

    <div class="table-responsive" style="overflow-y: hidden">
        <div class="Filterng">
            <div class="Help">
                <div class="Point Size">Point</div>
                <div class="Member Size">Member</div>
            </div>
            <div class="Up_Reset">
                <table>
                    <tr>
                        <td>
                            <asp:Button ID="Tom_MemberButton" runat="server" CssClass="Top_User" OnClick="Tom_MemberButton_Click" />
                        </td>
                    </tr>
                </table>
            </div>

            <div class="M_Search">
                <div class="form-inline">
                    <div class="form-group">
                        <asp:TextBox placeholder="User ID" ID="UserIDTextBox" runat="server" CssClass="form-control" autocomplete="off"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <asp:Button ID="FindButton" runat="server" CssClass="btn btn-primary" Text="Find" OnClick="FindButton_Click" ValidationGroup="S" />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="UserIDTextBox" CssClass="Error" ErrorMessage="Required" ValidationGroup="S"></asp:RequiredFieldValidator>
                    </div>
                </div>
            </div>
        </div>

        <div class="Contain">
            <div class="Main_Tree">
                <asp:FormView ID="Main_FormView" runat="server" DataSourceID="Main_BinarySQL" Width="100%" DataKeyNames="MemberID">
                    <ItemTemplate>
                        <a href='<%#Eval("MemberID","Member_Binarytree.aspx?M={0}")%>' data-toggle="tooltip" title="<%# String.Format("{0} {1}", Eval("Name"), Eval("Phone")) %>" data-placement="right">
                            <table>
                                <tr>
                                    <td colspan="2" class="M_UserName">
                                        <asp:Label ID="UserNameLabel" runat="server" Text='<%# Bind("UserName") %>' />
                                        <asp:Label ID="Member_Package_Short_KeyLabel" runat="server" Text='<%# Bind("Member_Package_Short_Key") %>' CssClass="Short_Key" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Point">
                                        <asp:Label ID="Left_Carry_PointLabel" runat="server" Text='<%# Bind("Left_Carry_Point") %>' />
                                    </td>
                                    <td class="Point">
                                        <asp:Label ID="Right_Carry_PointLabel" runat="server" Text='<%# Bind("Right_Carry_Point") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Member">
                                        <asp:Label ID="TotalLeft_MemberLabel" runat="server" Text='<%# Bind("TotalLeft_Member") %>' />
                                    </td>
                                    <td class="Member">
                                        <asp:Label ID="TotalRight_MemberLabel" runat="server" Text='<%# Bind("TotalRight_Member") %>' />
                                    </td>
                                </tr>
                            </table>
                        </a>
                    </ItemTemplate>
                </asp:FormView>
                <asp:SqlDataSource ID="Main_BinarySQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.UserName,Registration.Name,Registration.Phone, Member.TotalLeft_Member, Member.TotalRight_Member, Member.Left_Carry_Point, Member.Right_Carry_Point, Member.MemberID, Member_Package.Member_Package_Short_Key, Member.Is_Identified FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID LEFT OUTER JOIN Member_Package ON Member.Member_Package_Serial = Member_Package.Package_Serial WHERE (Member.MemberID = @MemberID)">
                    <SelectParameters>
                        <asp:QueryStringParameter Name="MemberID" QueryStringField="M" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>

            <div class="VR0"></div>
            <div class="VR1"></div>
            <div class="Main_Left">
                <asp:FormView ID="ML_FormView" runat="server" DataSourceID="ML_SQL" Width="100%" DataKeyNames="MemberID">
                    <ItemTemplate>
                        <a href='<%#Eval("MemberID","Member_Binarytree.aspx?M={0}")%>' data-toggle="tooltip" title="<%# String.Format("{0} {1}", Eval("Name"), Eval("Phone")) %>" data-placement="right">
                            <table>
                                <tr>
                                    <td colspan="2" class="M_UserName">
                                        <asp:Label ID="UserNameLabel" runat="server" Text='<%# Bind("UserName") %>' />
                                        <asp:Label ID="Member_Package_Short_KeyLabel" runat="server" Text='<%# Bind("Member_Package_Short_Key") %>' CssClass="Short_Key" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Point">
                                        <asp:Label ID="Left_Carry_PointLabel" runat="server" Text='<%# Bind("Left_Carry_Point") %>' />
                                    </td>
                                    <td class="Point">
                                        <asp:Label ID="Right_Carry_PointLabel" runat="server" Text='<%# Bind("Right_Carry_Point") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Member">
                                        <asp:Label ID="TotalLeft_MemberLabel" runat="server" Text='<%# Bind("TotalLeft_Member") %>' />
                                    </td>
                                    <td class="Member">
                                        <asp:Label ID="TotalRight_MemberLabel" runat="server" Text='<%# Bind("TotalRight_Member") %>' />
                                    </td>
                                </tr>
                            </table>
                        </a>
                    </ItemTemplate>
                </asp:FormView>
                <asp:SqlDataSource ID="ML_SQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.UserName,Registration.Name,Registration.Phone, Member.TotalLeft_Member, Member.TotalRight_Member, Member.Left_Carry_Point, Member.Right_Carry_Point, Member.MemberID, Member_Package.Member_Package_Short_Key, Member.Is_Identified FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID LEFT OUTER JOIN Member_Package ON Member.Member_Package_Serial = Member_Package.Package_Serial WHERE (Member.PositionMemberID = @MemberID) AND (Member.PositionType = N'Left')">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="Main_FormView" Name="MemberID" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>

            <div class="Hr1"></div>
            <div class="VR2"></div>
            <div class="Main_Right">
                <asp:FormView ID="MR_FormView" runat="server" DataSourceID="MR_SQL" Width="100%" DataKeyNames="MemberID">
                    <ItemTemplate>
                        <a href='<%#Eval("MemberID","Member_Binarytree.aspx?M={0}")%>' data-toggle="tooltip" title="<%# String.Format("{0} {1}", Eval("Name"), Eval("Phone")) %>" data-placement="right">
                            <table>
                                <tr>
                                    <td colspan="2" class="M_UserName">
                                        <asp:Label ID="UserNameLabel" runat="server" Text='<%# Bind("UserName") %>' />
                                        <asp:Label ID="Member_Package_Short_KeyLabel" runat="server" Text='<%# Bind("Member_Package_Short_Key") %>' CssClass="Short_Key" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Point">
                                        <asp:Label ID="Left_Carry_PointLabel" runat="server" Text='<%# Bind("Left_Carry_Point") %>' />
                                    </td>
                                    <td class="Point">
                                        <asp:Label ID="Right_Carry_PointLabel" runat="server" Text='<%# Bind("Right_Carry_Point") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Member">
                                        <asp:Label ID="TotalLeft_MemberLabel" runat="server" Text='<%# Bind("TotalLeft_Member") %>' />
                                    </td>
                                    <td class="Member">
                                        <asp:Label ID="TotalRight_MemberLabel" runat="server" Text='<%# Bind("TotalRight_Member") %>' />
                                    </td>
                                </tr>
                            </table>
                        </a>
                    </ItemTemplate>
                </asp:FormView>
                <asp:SqlDataSource ID="MR_SQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.UserName,Registration.Name,Registration.Phone, Member.TotalLeft_Member, Member.TotalRight_Member, Member.Left_Carry_Point, Member.Right_Carry_Point, Member.MemberID, Member_Package.Member_Package_Short_Key, Member.Is_Identified FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID LEFT OUTER JOIN Member_Package ON Member.Member_Package_Serial = Member_Package.Package_Serial WHERE (Member.PositionMemberID = @MemberID) AND (Member.PositionType = N'Right')">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="Main_FormView" Name="MemberID" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>

            <div class="VR3"></div>
            <div class="VR4"></div>
            <div class="Main_Left_Left">
                <asp:FormView ID="LTL_FormView" runat="server" DataSourceID="LTL_SQL" Width="100%" DataKeyNames="MemberID">
                    <ItemTemplate>
                        <a href='<%#Eval("MemberID","Member_Binarytree.aspx?M={0}")%>' data-toggle="tooltip" title="<%# String.Format("{0} {1}", Eval("Name"), Eval("Phone")) %>" data-placement="right">
                            <table>
                                <tr>
                                    <td colspan="2" class="M_UserName">
                                        <asp:Label ID="UserNameLabel" runat="server" Text='<%# Bind("UserName") %>' />
                                        <asp:Label ID="Member_Package_Short_KeyLabel" runat="server" Text='<%# Bind("Member_Package_Short_Key") %>' CssClass="Short_Key" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Point">
                                        <asp:Label ID="Left_Carry_PointLabel" runat="server" Text='<%# Bind("Left_Carry_Point") %>' />
                                    </td>
                                    <td class="Point">
                                        <asp:Label ID="Right_Carry_PointLabel" runat="server" Text='<%# Bind("Right_Carry_Point") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Member">
                                        <asp:Label ID="TotalLeft_MemberLabel" runat="server" Text='<%# Bind("TotalLeft_Member") %>' />
                                    </td>
                                    <td class="Member">
                                        <asp:Label ID="TotalRight_MemberLabel" runat="server" Text='<%# Bind("TotalRight_Member") %>' />
                                    </td>
                                </tr>
                            </table>
                        </a>
                    </ItemTemplate>
                </asp:FormView>
                <asp:SqlDataSource ID="LTL_SQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.UserName,Registration.Name,Registration.Phone, Member.TotalLeft_Member, Member.TotalRight_Member, Member.Left_Carry_Point, Member.Right_Carry_Point, Member.MemberID, Member_Package.Member_Package_Short_Key, Member.Is_Identified FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID LEFT OUTER JOIN Member_Package ON Member.Member_Package_Serial = Member_Package.Package_Serial WHERE (Member.PositionMemberID = @MemberID) AND (Member.PositionType = N'Left')">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="ML_FormView" Name="MemberID" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>

            <div class="Hr2"></div>
            <div class="VR5"></div>
            <div class="Main_Left_Right">
                <asp:FormView ID="LTR_FormView" runat="server" DataSourceID="LTR_SQL" Width="100%" DataKeyNames="MemberID">
                    <ItemTemplate>
                        <a href='<%#Eval("MemberID","Member_Binarytree.aspx?M={0}")%>' data-toggle="tooltip" title="<%# String.Format("{0} {1}", Eval("Name"), Eval("Phone")) %>" data-placement="right">
                            <table>
                                <tr>
                                    <td colspan="2" class="M_UserName">
                                        <asp:Label ID="UserNameLabel" runat="server" Text='<%# Bind("UserName") %>' />
                                        <asp:Label ID="Member_Package_Short_KeyLabel" runat="server" Text='<%# Bind("Member_Package_Short_Key") %>' CssClass="Short_Key" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Point">
                                        <asp:Label ID="Left_Carry_PointLabel" runat="server" Text='<%# Bind("Left_Carry_Point") %>' />
                                    </td>
                                    <td class="Point">
                                        <asp:Label ID="Right_Carry_PointLabel" runat="server" Text='<%# Bind("Right_Carry_Point") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Member">
                                        <asp:Label ID="TotalLeft_MemberLabel" runat="server" Text='<%# Bind("TotalLeft_Member") %>' />
                                    </td>
                                    <td class="Member">
                                        <asp:Label ID="TotalRight_MemberLabel" runat="server" Text='<%# Bind("TotalRight_Member") %>' />
                                    </td>
                                </tr>
                            </table>
                        </a>
                    </ItemTemplate>
                    
                </asp:FormView>
                <asp:SqlDataSource ID="LTR_SQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.UserName,Registration.Name,Registration.Phone, Member.TotalLeft_Member, Member.TotalRight_Member, Member.Left_Carry_Point, Member.Right_Carry_Point, Member.MemberID, Member_Package.Member_Package_Short_Key, Member.Is_Identified FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID LEFT OUTER JOIN Member_Package ON Member.Member_Package_Serial = Member_Package.Package_Serial WHERE (Member.PositionMemberID = @MemberID) AND (Member.PositionType = N'Right')">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="ML_FormView" Name="MemberID" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>

            <div class="VR6"></div>
            <div class="VR7"></div>
            <div class="Main_Right_Left">
                <asp:FormView ID="RTL_FormView" runat="server" DataSourceID="RTL_SQL" Width="100%" DataKeyNames="MemberID">
                    <ItemTemplate>
                        <a href='<%#Eval("MemberID","Member_Binarytree.aspx?M={0}")%>' data-toggle="tooltip" title="<%# String.Format("{0} {1}", Eval("Name"), Eval("Phone")) %>" data-placement="right">
                            <table>
                                <tr>
                                    <td colspan="2" class="M_UserName">
                                        <asp:Label ID="UserNameLabel" runat="server" Text='<%# Bind("UserName") %>' />
                                        <asp:Label ID="Member_Package_Short_KeyLabel" runat="server" Text='<%# Bind("Member_Package_Short_Key") %>' CssClass="Short_Key" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Point">
                                        <asp:Label ID="Left_Carry_PointLabel" runat="server" Text='<%# Bind("Left_Carry_Point") %>' />
                                    </td>
                                    <td class="Point">
                                        <asp:Label ID="Right_Carry_PointLabel" runat="server" Text='<%# Bind("Right_Carry_Point") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Member">
                                        <asp:Label ID="TotalLeft_MemberLabel" runat="server" Text='<%# Bind("TotalLeft_Member") %>' />
                                    </td>
                                    <td class="Member">
                                        <asp:Label ID="TotalRight_MemberLabel" runat="server" Text='<%# Bind("TotalRight_Member") %>' />
                                    </td>
                                </tr>
                            </table>
                        </a>
                    </ItemTemplate>
                    
                </asp:FormView>
                <asp:SqlDataSource ID="RTL_SQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.UserName,Registration.Name,Registration.Phone, Member.TotalLeft_Member, Member.TotalRight_Member, Member.Left_Carry_Point, Member.Right_Carry_Point, Member.MemberID, Member_Package.Member_Package_Short_Key, Member.Is_Identified FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID LEFT OUTER JOIN Member_Package ON Member.Member_Package_Serial = Member_Package.Package_Serial WHERE (Member.PositionMemberID = @MemberID) AND (Member.PositionType = N'Left')">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="MR_FormView" Name="MemberID" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>

            <div class="Hr3"></div>
            <div class="VR8"></div>
            <div class="Main_Right_Right">
                <asp:FormView ID="RTR_FormView" runat="server" DataSourceID="RTR_SQL" Width="100%" DataKeyNames="MemberID">
                    <ItemTemplate>
                        <a href='<%#Eval("MemberID","Member_Binarytree.aspx?M={0}")%>' data-toggle="tooltip" title="<%# String.Format("{0} {1}", Eval("Name"), Eval("Phone")) %>" data-placement="right">
                            <table>
                                <tr>
                                    <td colspan="2" class="M_UserName">
                                        <asp:Label ID="UserNameLabel" runat="server" Text='<%# Bind("UserName") %>' />
                                        <asp:Label ID="Member_Package_Short_KeyLabel" runat="server" Text='<%# Bind("Member_Package_Short_Key") %>' CssClass="Short_Key" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Point">
                                        <asp:Label ID="Left_Carry_PointLabel" runat="server" Text='<%# Bind("Left_Carry_Point") %>' />
                                    </td>
                                    <td class="Point">
                                        <asp:Label ID="Right_Carry_PointLabel" runat="server" Text='<%# Bind("Right_Carry_Point") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Member">
                                        <asp:Label ID="TotalLeft_MemberLabel" runat="server" Text='<%# Bind("TotalLeft_Member") %>' />
                                    </td>
                                    <td class="Member">
                                        <asp:Label ID="TotalRight_MemberLabel" runat="server" Text='<%# Bind("TotalRight_Member") %>' />
                                    </td>
                                </tr>
                            </table>

                        </a>

                    </ItemTemplate>
                    
                </asp:FormView>
                <asp:SqlDataSource ID="RTR_SQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.UserName,Registration.Name,Registration.Phone, Member.TotalLeft_Member, Member.TotalRight_Member, Member.Left_Carry_Point, Member.Right_Carry_Point, Member.MemberID, Member_Package.Member_Package_Short_Key, Member.Is_Identified FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID LEFT OUTER JOIN Member_Package ON Member.Member_Package_Serial = Member_Package.Package_Serial WHERE (Member.PositionMemberID = @MemberID) AND (Member.PositionType = N'Right')">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="MR_FormView" Name="MemberID" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>

            <div class="VR9"></div>
            <div class="VR10"></div>
            <div class="Main_Left_Left_Left">
                <asp:FormView ID="LBL1_FormView" runat="server" DataSourceID="LBL1_SQL" Width="100%" DataKeyNames="MemberID">
                    <ItemTemplate>
                        <a href='<%#Eval("MemberID","Member_Binarytree.aspx?M={0}")%>' data-toggle="tooltip" title="<%# String.Format("{0} {1}", Eval("Name"), Eval("Phone")) %>" data-placement="right">
                            <table>
                                <tr>
                                    <td colspan="2" class="M_UserName">
                                        <asp:Label ID="UserNameLabel" runat="server" Text='<%# Bind("UserName") %>' />
                                        <asp:Label ID="Member_Package_Short_KeyLabel" runat="server" Text='<%# Bind("Member_Package_Short_Key") %>' CssClass="Short_Key" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Point">
                                        <asp:Label ID="Left_Carry_PointLabel" runat="server" Text='<%# Bind("Left_Carry_Point") %>' />
                                    </td>
                                    <td class="Point">
                                        <asp:Label ID="Right_Carry_PointLabel" runat="server" Text='<%# Bind("Right_Carry_Point") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Member">
                                        <asp:Label ID="TotalLeft_MemberLabel" runat="server" Text='<%# Bind("TotalLeft_Member") %>' />
                                    </td>
                                    <td class="Member">
                                        <asp:Label ID="TotalRight_MemberLabel" runat="server" Text='<%# Bind("TotalRight_Member") %>' />
                                    </td>
                                </tr>
                            </table>
                        </a>
                    </ItemTemplate>
                    
                </asp:FormView>
                <asp:SqlDataSource ID="LBL1_SQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.UserName,Registration.Name,Registration.Phone, Member.TotalLeft_Member, Member.TotalRight_Member, Member.Left_Carry_Point, Member.Right_Carry_Point, Member.MemberID, Member_Package.Member_Package_Short_Key, Member.Is_Identified FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID LEFT OUTER JOIN Member_Package ON Member.Member_Package_Serial = Member_Package.Package_Serial WHERE (Member.PositionMemberID = @MemberID) AND (Member.PositionType = N'Left')">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="LTL_FormView" Name="MemberID" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>

            <div class="Hr4"></div>
            <div class="VR11"></div>
            <div class="Main_Left_Left_Right">
                <asp:FormView ID="LBR1_FormView" runat="server" DataSourceID="LBR1_SQL" Width="100%" DataKeyNames="MemberID">
                    <ItemTemplate>
                        <a href='<%#Eval("MemberID","Member_Binarytree.aspx?M={0}")%>' data-toggle="tooltip" title="<%# String.Format("{0} {1}", Eval("Name"), Eval("Phone")) %>" data-placement="right">
                            <table>
                                <tr>
                                    <td colspan="2" class="M_UserName">
                                        <asp:Label ID="UserNameLabel" runat="server" Text='<%# Bind("UserName") %>' />
                                        <asp:Label ID="Member_Package_Short_KeyLabel" runat="server" Text='<%# Bind("Member_Package_Short_Key") %>' CssClass="Short_Key" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Point">
                                        <asp:Label ID="Left_Carry_PointLabel" runat="server" Text='<%# Bind("Left_Carry_Point") %>' />
                                    </td>
                                    <td class="Point">
                                        <asp:Label ID="Right_Carry_PointLabel" runat="server" Text='<%# Bind("Right_Carry_Point") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Member">
                                        <asp:Label ID="TotalLeft_MemberLabel" runat="server" Text='<%# Bind("TotalLeft_Member") %>' />
                                    </td>
                                    <td class="Member">
                                        <asp:Label ID="TotalRight_MemberLabel" runat="server" Text='<%# Bind("TotalRight_Member") %>' />
                                    </td>
                                </tr>
                            </table>
                        </a>
                    </ItemTemplate>
                    
                </asp:FormView>
                <asp:SqlDataSource ID="LBR1_SQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.UserName,Registration.Name,Registration.Phone, Member.TotalLeft_Member, Member.TotalRight_Member, Member.Left_Carry_Point, Member.Right_Carry_Point, Member.MemberID, Member_Package.Member_Package_Short_Key, Member.Is_Identified FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID LEFT OUTER JOIN Member_Package ON Member.Member_Package_Serial = Member_Package.Package_Serial WHERE (Member.PositionMemberID = @MemberID) AND (Member.PositionType = N'Right')">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="LTL_FormView" Name="MemberID" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>

            <div class="VR12"></div>
            <div class="VR13"></div>
            <div class="Main_Left_Right_Left">
                <asp:FormView ID="LBL2_FormView" runat="server" DataSourceID="LBL2_SQL" Width="100%" DataKeyNames="MemberID">
                    <ItemTemplate>
                        <a href='<%#Eval("MemberID","Member_Binarytree.aspx?M={0}")%>' data-toggle="tooltip" title="<%# String.Format("{0} {1}", Eval("Name"), Eval("Phone")) %>" data-placement="right">
                            <table>
                                <tr>
                                    <td colspan="2" class="M_UserName">
                                        <asp:Label ID="UserNameLabel" runat="server" Text='<%# Bind("UserName") %>' />
                                        <asp:Label ID="Member_Package_Short_KeyLabel" runat="server" Text='<%# Bind("Member_Package_Short_Key") %>' CssClass="Short_Key" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Point">
                                        <asp:Label ID="Left_Carry_PointLabel" runat="server" Text='<%# Bind("Left_Carry_Point") %>' />
                                    </td>
                                    <td class="Point">
                                        <asp:Label ID="Right_Carry_PointLabel" runat="server" Text='<%# Bind("Right_Carry_Point") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Member">
                                        <asp:Label ID="TotalLeft_MemberLabel" runat="server" Text='<%# Bind("TotalLeft_Member") %>' />
                                    </td>
                                    <td class="Member">
                                        <asp:Label ID="TotalRight_MemberLabel" runat="server" Text='<%# Bind("TotalRight_Member") %>' />
                                    </td>
                                </tr>
                            </table>
                        </a>
                    </ItemTemplate>
                    
                </asp:FormView>
                <asp:SqlDataSource ID="LBL2_SQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.UserName,Registration.Name,Registration.Phone, Member.TotalLeft_Member, Member.TotalRight_Member, Member.Left_Carry_Point, Member.Right_Carry_Point, Member.MemberID, Member_Package.Member_Package_Short_Key, Member.Is_Identified FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID LEFT OUTER JOIN Member_Package ON Member.Member_Package_Serial = Member_Package.Package_Serial WHERE (Member.PositionMemberID = @MemberID) AND (Member.PositionType = N'Left')">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="LTR_FormView" Name="MemberID" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>

            <div class="Hr5"></div>
            <div class="VR14"></div>
            <div class="Main_Left_Right_Right">
                <asp:FormView ID="LBR2_FormView" runat="server" DataSourceID="LBR2_SQL" Width="100%" DataKeyNames="MemberID">
                    <ItemTemplate>
                        <a href='<%#Eval("MemberID","Member_Binarytree.aspx?M={0}")%>' data-toggle="tooltip" title="<%# String.Format("{0} {1}", Eval("Name"), Eval("Phone")) %>" data-placement="right">
                            <table>
                                <tr>
                                    <td colspan="2" class="M_UserName">
                                        <asp:Label ID="UserNameLabel" runat="server" Text='<%# Bind("UserName") %>' />
                                        <asp:Label ID="Member_Package_Short_KeyLabel" runat="server" Text='<%# Bind("Member_Package_Short_Key") %>' CssClass="Short_Key" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Point">
                                        <asp:Label ID="Left_Carry_PointLabel" runat="server" Text='<%# Bind("Left_Carry_Point") %>' />
                                    </td>
                                    <td class="Point">
                                        <asp:Label ID="Right_Carry_PointLabel" runat="server" Text='<%# Bind("Right_Carry_Point") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Member">
                                        <asp:Label ID="TotalLeft_MemberLabel" runat="server" Text='<%# Bind("TotalLeft_Member") %>' />
                                    </td>
                                    <td class="Member">
                                        <asp:Label ID="TotalRight_MemberLabel" runat="server" Text='<%# Bind("TotalRight_Member") %>' />
                                    </td>
                                </tr>
                            </table>
                        </a>
                    </ItemTemplate>
                    
                </asp:FormView>
                <asp:SqlDataSource ID="LBR2_SQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.UserName,Registration.Name,Registration.Phone, Member.TotalLeft_Member, Member.TotalRight_Member, Member.Left_Carry_Point, Member.Right_Carry_Point, Member.MemberID, Member_Package.Member_Package_Short_Key, Member.Is_Identified FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID LEFT OUTER JOIN Member_Package ON Member.Member_Package_Serial = Member_Package.Package_Serial WHERE (Member.PositionMemberID = @MemberID) AND (Member.PositionType = N'Right')">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="LTR_FormView" Name="MemberID" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>

            <div class="VR15"></div>
            <div class="VR16"></div>
            <div class="Main_Right_Left_Left">
                <asp:FormView ID="RBL1_FormView" runat="server" DataSourceID="RBL1_SQL" Width="100%" DataKeyNames="MemberID">
                    <ItemTemplate>
                        <a href='<%#Eval("MemberID","Member_Binarytree.aspx?M={0}")%>' data-toggle="tooltip" title="<%# String.Format("{0} {1}", Eval("Name"), Eval("Phone")) %>" data-placement="right">
                            <table>
                                <tr>
                                    <td colspan="2" class="M_UserName">
                                        <asp:Label ID="UserNameLabel" runat="server" Text='<%# Bind("UserName") %>' />
                                        <asp:Label ID="Member_Package_Short_KeyLabel" runat="server" Text='<%# Bind("Member_Package_Short_Key") %>' CssClass="Short_Key" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Point">
                                        <asp:Label ID="Left_Carry_PointLabel" runat="server" Text='<%# Bind("Left_Carry_Point") %>' />
                                    </td>
                                    <td class="Point">
                                        <asp:Label ID="Right_Carry_PointLabel" runat="server" Text='<%# Bind("Right_Carry_Point") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Member">
                                        <asp:Label ID="TotalLeft_MemberLabel" runat="server" Text='<%# Bind("TotalLeft_Member") %>' />
                                    </td>
                                    <td class="Member">
                                        <asp:Label ID="TotalRight_MemberLabel" runat="server" Text='<%# Bind("TotalRight_Member") %>' />
                                    </td>
                                </tr>
                            </table>
                        </a>
                    </ItemTemplate>
                    
                </asp:FormView>
                <asp:SqlDataSource ID="RBL1_SQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.UserName,Registration.Name,Registration.Phone, Member.TotalLeft_Member, Member.TotalRight_Member, Member.Left_Carry_Point, Member.Right_Carry_Point, Member.MemberID, Member_Package.Member_Package_Short_Key, Member.Is_Identified FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID LEFT OUTER JOIN Member_Package ON Member.Member_Package_Serial = Member_Package.Package_Serial WHERE (Member.PositionMemberID = @MemberID) AND (Member.PositionType = N'Left')">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="RTL_FormView" Name="MemberID" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>

            <div class="Hr6"></div>
            <div class="VR17"></div>
            <div class="Main_Right_Left_Right">
                <asp:FormView ID="RBR1_FormView" runat="server" DataSourceID="RBR1_SQL" Width="100%" DataKeyNames="MemberID">
                    <ItemTemplate>
                        <a href='<%#Eval("MemberID","Member_Binarytree.aspx?M={0}")%>' data-toggle="tooltip" title="<%# String.Format("{0} {1}", Eval("Name"), Eval("Phone")) %>" data-placement="right">
                            <table>
                                <tr>
                                    <td colspan="2" class="M_UserName">
                                        <asp:Label ID="UserNameLabel" runat="server" Text='<%# Bind("UserName") %>' />
                                        <asp:Label ID="Member_Package_Short_KeyLabel" runat="server" Text='<%# Bind("Member_Package_Short_Key") %>' CssClass="Short_Key" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Point">
                                        <asp:Label ID="Left_Carry_PointLabel" runat="server" Text='<%# Bind("Left_Carry_Point") %>' />
                                    </td>
                                    <td class="Point">
                                        <asp:Label ID="Right_Carry_PointLabel" runat="server" Text='<%# Bind("Right_Carry_Point") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Member">
                                        <asp:Label ID="TotalLeft_MemberLabel" runat="server" Text='<%# Bind("TotalLeft_Member") %>' />
                                    </td>
                                    <td class="Member">
                                        <asp:Label ID="TotalRight_MemberLabel" runat="server" Text='<%# Bind("TotalRight_Member") %>' />
                                    </td>
                                </tr>
                            </table>
                        </a>
                    </ItemTemplate>
                    
                </asp:FormView>
                <asp:SqlDataSource ID="RBR1_SQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.UserName,Registration.Name,Registration.Phone, Member.TotalLeft_Member, Member.TotalRight_Member, Member.Left_Carry_Point, Member.Right_Carry_Point, Member.MemberID, Member_Package.Member_Package_Short_Key, Member.Is_Identified FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID LEFT OUTER JOIN Member_Package ON Member.Member_Package_Serial = Member_Package.Package_Serial WHERE (Member.PositionMemberID = @MemberID) AND (Member.PositionType = N'Right')">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="RTL_FormView" Name="MemberID" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>

            <div class="VR18"></div>
            <div class="VR19"></div>
            <div class="Main_Right_Right_Left">
                <asp:FormView ID="RBL2_FormView" runat="server" DataSourceID="RBL2_SQL" Width="100%" DataKeyNames="MemberID">
                    <ItemTemplate>
                        <a href='<%#Eval("MemberID","Member_Binarytree.aspx?M={0}")%>' data-toggle="tooltip" title="<%# String.Format("{0} {1}", Eval("Name"), Eval("Phone")) %>" data-placement="right">
                            <table>
                                <tr>
                                    <td colspan="2" class="M_UserName">
                                        <asp:Label ID="UserNameLabel" runat="server" Text='<%# Bind("UserName") %>' />
                                        <asp:Label ID="Member_Package_Short_KeyLabel" runat="server" Text='<%# Bind("Member_Package_Short_Key") %>' CssClass="Short_Key" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Point">
                                        <asp:Label ID="Left_Carry_PointLabel" runat="server" Text='<%# Bind("Left_Carry_Point") %>' />
                                    </td>
                                    <td class="Point">
                                        <asp:Label ID="Right_Carry_PointLabel" runat="server" Text='<%# Bind("Right_Carry_Point") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Member">
                                        <asp:Label ID="TotalLeft_MemberLabel" runat="server" Text='<%# Bind("TotalLeft_Member") %>' />
                                    </td>
                                    <td class="Member">
                                        <asp:Label ID="TotalRight_MemberLabel" runat="server" Text='<%# Bind("TotalRight_Member") %>' />
                                    </td>
                                </tr>
                            </table>
                        </a>
                    </ItemTemplate>
                    
                </asp:FormView>
                <asp:SqlDataSource ID="RBL2_SQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.UserName,Registration.Name,Registration.Phone, Member.TotalLeft_Member, Member.TotalRight_Member, Member.Left_Carry_Point, Member.Right_Carry_Point, Member.MemberID, Member_Package.Member_Package_Short_Key, Member.Is_Identified FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID LEFT OUTER JOIN Member_Package ON Member.Member_Package_Serial = Member_Package.Package_Serial WHERE (Member.PositionMemberID = @MemberID) AND (Member.PositionType = N'Left')">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="RTR_FormView" Name="MemberID" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>

            <div class="Hr7"></div>
            <div class="VR20"></div>
            <div class="Main_Right_Right_Right">
                <asp:FormView ID="RBR2_FormView" runat="server" DataSourceID="RBR2_SQL" Width="100%" DataKeyNames="MemberID">
                    <ItemTemplate>
                        <a href='<%#Eval("MemberID","Member_Binarytree.aspx?M={0}")%>' data-toggle="tooltip" title="<%# String.Format("{0} {1}", Eval("Name"), Eval("Phone")) %>" data-placement="right">
                            <table>
                                <tr>
                                    <td colspan="2" class="M_UserName">
                                        <asp:Label ID="UserNameLabel" runat="server" Text='<%# Bind("UserName") %>' />
                                        <asp:Label ID="Member_Package_Short_KeyLabel" runat="server" Text='<%# Bind("Member_Package_Short_Key") %>' CssClass="Short_Key" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Point">
                                        <asp:Label ID="Left_Carry_PointLabel" runat="server" Text='<%# Bind("Left_Carry_Point") %>' />
                                    </td>
                                    <td class="Point">
                                        <asp:Label ID="Right_Carry_PointLabel" runat="server" Text='<%# Bind("Right_Carry_Point") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Member">
                                        <asp:Label ID="TotalLeft_MemberLabel" runat="server" Text='<%# Bind("TotalLeft_Member") %>' />
                                    </td>
                                    <td class="Member">
                                        <asp:Label ID="TotalRight_MemberLabel" runat="server" Text='<%# Bind("TotalRight_Member") %>' />
                                    </td>
                                </tr>
                            </table>
                        </a>
                    </ItemTemplate>
                    
                </asp:FormView>
                <asp:SqlDataSource ID="RBR2_SQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.UserName,Registration.Name,Registration.Phone, Member.TotalLeft_Member, Member.TotalRight_Member, Member.Left_Carry_Point, Member.Right_Carry_Point, Member.MemberID, Member_Package.Member_Package_Short_Key, Member.Is_Identified FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID LEFT OUTER JOIN Member_Package ON Member.Member_Package_Serial = Member_Package.Package_Serial WHERE (Member.PositionMemberID = @MemberID) AND (Member.PositionType = N'Right')">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="RTR_FormView" Name="MemberID" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>
        </div>

        <div class="Down_Filter">
            <div class="D_Left">
                <asp:Button ID="Down_Left_Button" runat="server" CssClass="Down_User" OnClick="Down_Left_Button_Click" />
            </div>
            <div class="D_Right">
                <asp:Button ID="Down_Right_Button" runat="server" CssClass="Down_User" OnClick="Down_Right_Button_Click" />
            </div>
        </div>
    </div>

    <asp:UpdateProgress ID="UpdateProgress" runat="server">
        <ProgressTemplate>
            <div id="progress_BG"></div>
            <div id="progress">
                <img src="../CSS/Image/loading.gif" alt="Loading..." />
                <br />
                <b>Loading...</b>
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>

    <script>
        $(function () {

            $("#Tree").addClass('L_Active');

            $('[data-toggle="tooltip"]').tooltip();

            //Autocomplete
            $('[id*=UserIDTextBox]').typeahead({
                minLength: 4,
                source: function (request, result) {
                    $.ajax({
                        url: "Member_Binarytree.aspx/Get_Tree_UserID",
                        data: JSON.stringify({ 'prefix': request }),
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (response) {
                            result($.map(JSON.parse(response.d), function (item) {
                                return item;
                            }));
                        }
                    });
                }
            });
        });
    </script>
</asp:Content>
