// My Unresolved Issue
const JQL_MY_UNRESOLVED_ISSUE =
    'assignee = currentUser() AND resolution = Unresolved order by updated DESC';

// Issue Assign to me
const JQL_ISSUE_ASSIGN_TO_ME = 'assignee = currentUser() order by updated DESC';

// My Report Issue
const JQL_MY_REPORT_ISSUE = 'reporter = currentUser() order by created DESC';
