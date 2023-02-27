
import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    var website: String?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = website
        navigationItem.largeTitleDisplayMode = .never
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let forward = UIBarButtonItem(barButtonSystemItem: .redo , target: webView, action: #selector(webView.goForward))
        let backward = UIBarButtonItem(barButtonSystemItem: .rewind, target: webView, action: #selector(webView.goBack))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [ backward, forward, progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        // Do any additional setup after loading the view.
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress),options: .new, context: nil)
        
        let url = URL(string: "https://"+(website ?? "hackingwithswift.com"))!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        openPage(action: UIAlertAction(title: website, style: .default))
    }
    
    func openPage(action: UIAlertAction){
        var url = URL(string: "https://")
        if let title = action.title {
            guard title != "Close" else { return }
            url = URL(string: "https://" + (website ?? "google") + ".com")!
        }else{
            url = URL(string: "https://" + (website ?? "google") + ".com")!
        }
        webView.load(URLRequest(url: url!))
    }
    
    @objc func openTapped(){
        let ac = UIAlertController(title: "Open Page", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        let url = navigationAction.request.url
        if let host = url?.host {
            if host.contains(website!){
                return WKNavigationActionPolicy(rawValue: 1)!
            }else{
                let ac = UIAlertController(title: "Access Denied", message: "You are not allowed to access the endpoint", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Close", style: .cancel, handler: openPage))
                ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
                present(ac, animated: true)
            }
        }
        return WKNavigationActionPolicy(rawValue: 0)!
    }

}

