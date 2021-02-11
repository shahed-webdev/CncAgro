<%@ Page Title="Customer Info" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="Added_Customer_Info.aspx.cs" Inherits="CncAgro.AccessMember.Added_Customer_Info" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">

    <asp:FormView ID="Customer_Info_FV" runat="server" DataSourceID="MemberDetailsSQL" Width="100%">
        <ItemTemplate>
            <div class="well">
                <h3><%#Eval("Name") %> <small><%#Eval("UserName") %></small></h3>
                <table class="table table-bordered table-hover">
                    <tr>
                        <td>Father's Name</td>
                        <td><%#Eval("FatherName") %></td>
                    </tr>
                    <tr>
                        <td>Mother's Name</td>
                        <td><%#Eval("MotherName") %></td>
                    </tr>
                    <tr>
                        <td>Gender</td>
                        <td><%#Eval("Gender") %></td>
                    </tr>
                    <tr>
                        <td>Present Address</td>
                        <td><%#Eval("Present_Address") %></td>
                    </tr>
                    <tr>
                        <td>Permanent Address</td>
                        <td><%#Eval("Permanent_Address") %></td>
                    </tr>
                    <tr>
                        <td>Phone</td>
                        <td><%#Eval("Phone") %></td>
                    </tr>
                    <tr>
                        <td>Email</td>
                        <td><%#Eval("Email") %></td>
                    </tr>
                    <tr>
                        <td>National ID</td>
                        <td><%#Eval("NationalID") %></td>
                    </tr>
                    <tr>
                        <td>Date of Birth</td>
                        <td><%#Eval("DateofBirth") %></td>
                    </tr>
                    <tr>
                        <td>Blood Group</td>
                        <td><%#Eval("BloodGroup") %></td>
                    </tr>
                    <tr>
                        <td>Placement User ID</td>
                        <td><%#Eval("P_UserName") %></td>
                    </tr>
                    <tr>
                        <td>Referral User ID</td>
                        <td><%#Eval("R_UserName") %></td>
                    </tr>
                    <tr>
                        <td>Team</td>
                        <td><%#Eval("PositionType") %></td>
                    </tr>
                    <tr>
                        <td>Nominee Name</td>
                        <td><%#Eval("Nominee_Name") %></td>
                    </tr>

                    <tr>
                        <td>Nominee Relationship</td>
                        <td><%#Eval("Nominee_Relationship") %></td>
                    </tr>

                    <tr>
                        <td>Nominee DOB</td>
                        <td><%#Eval("Nominee_DOB") %></td>
                    </tr>
                    <tr>
                        <td>Bank<%#Eval("Bank") %></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>Branch<%#Eval("Branch") %></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>Account Name</td>
                        <td><%#Eval("AccountName") %></td>
                    </tr>
                    <tr>
                        <td>Account No.</td>
                        <td><%#Eval("AccountNo") %></td>
                    </tr>
                    <tr>
                        <td>Reg. Date</td>
                        <td><%#Eval("SignUpDate","{0:d MMM yyyy}") %></td>
                    </tr>
                </table>

            </div>
            <button type="button" class="btn btn-primary hidden-print" onclick="window.print();"><span class="glyphicon glyphicon-print"></span> Print</button>
        </ItemTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="MemberDetailsSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.Name, Registration.FatherName, Registration.Gender, Registration.NationalID, Registration.Present_Address, Registration.Permanent_Address, Registration.Phone, Registration.Email, Registration.MotherName, Registration.UserName, Member.Is_Identified, Member.SignUpDate, Member.MemberID, Registration.RegistrationID, Registration.DateofBirth, Registration.BloodGroup, P_Registration.UserName AS P_UserName, R_Registration.UserName AS R_UserName, Member.PositionMemberID, Member.Default_MemberStatus, Member.PositionType, Member.MemberRegistrationID, Member.Nominee_Name, Member.Nominee_Relationship,Member.Nominee_DOB, Member.Bank, Member.Branch, Member.AccountName, Member.AccountNo FROM Registration AS R_Registration INNER JOIN Member AS R_Member ON R_Registration.RegistrationID = R_Member.MemberRegistrationID RIGHT OUTER JOIN Registration AS P_Registration INNER JOIN Member AS P_Member ON P_Registration.RegistrationID = P_Member.MemberRegistrationID RIGHT OUTER JOIN Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID ON P_Member.MemberID = Member.PositionMemberID ON R_Member.MemberID = Member.Referral_MemberID WHERE (Registration.Category = N'Member') AND (Member.MemberID = @MemberID)">
        <SelectParameters>
            <asp:QueryStringParameter Name="MemberID" QueryStringField="member" />
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>
