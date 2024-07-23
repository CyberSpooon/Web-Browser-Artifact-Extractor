# Web-Browser-Artifact-Extractor
Here’s a quick and dirty powershell script to extract web browser artifacts from Google Chrome, Mozilla Firefox, and Microsoft Edge for later analysis.

NOTE: This script currently only collects browser history artifacts from Edge, Chrome, and Firefox. Further functionality will be added. This script only works on Windows machines.

The below tools can be used to view collected artifacts:

- DB Browser for SQLite - https://sqlitebrowser.org/
- Nirsoft Web Browser Tools - https://www.nirsoft.net/web_browser_tools.html
- Foxton Forensics Browser History Viewer - https://www.foxtonforensics.com/browser-history-viewer/
- Hindsight - https://github.com/obsidianforensics/hindsight

NOTE: Since WebKit/Chrome records timestamps as the number of microseconds since January 1, 1601 instead of Epoch time, the timestamps for WebKit/Chrome based browsers will need to be converted. Use https://www.epochconverter.com/webkit or the SQLite query listed below for the conversion:

```
SELECT id,url,title,visit_count,typed_count,last_visit_time,hidden, (datetime((last_visit_time /1000000)-11644473600, 'unixepoch', 'localtime')) AS last_visit_time_Converted FROM urls
ORDER BY last_visit_time DESC;
```
