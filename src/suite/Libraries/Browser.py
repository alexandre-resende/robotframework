class Browser(object):

    def __init__(self):
        pass

    def get_options_firefox(self, download_dir):
        from selenium import webdriver
        from selenium.webdriver.firefox.options import Options
        options = Options();
        options.set_preference("browser.download.folderList",2);
        options.set_preference("browser.download.manager.showWhenStarting", False);
        options.set_preference("browser.download.dir",download_dir)
        options.set_preference("browser.helperApps.neverAsk.saveToDisk", "application/octet-stream,image/png,image/jpeg,text/csv,text/xml,application/xml,application/vnd.ms-excel,application/x-excel,application/x-msexcel,application/excel,application/pdf");
        return options;

    def get_options_headlessfirefox(self, download_dir):
        from selenium import webdriver
        from selenium.webdriver.firefox.options import Options
        options = Options();
        options.set_headless(headless=True);
        options.set_preference("browser.download.folderList",2);
        options.set_preference("browser.download.manager.showWhenStarting", False);
        options.set_preference("browser.download.dir",download_dir)
        options.set_preference("browser.helperApps.neverAsk.saveToDisk", "application/octet-stream,image/png,image/jpeg,text/csv,text/xml,application/xml,application/vnd.ms-excel,application/x-excel,application/x-msexcel,application/excel,application/pdf");
        return options;

    def get_options_chrome(self, download_dir):
        from selenium import webdriver
        from selenium.webdriver.chrome.options import Options
        options = Options();
        prefs = {"download.default_directory": download_dir,"download.directory_upgrade": True,"download.prompt_for_download": False,"safebrowsing.enabled": False,"safebrowsing.disable_download_protection": True,"page.setDownloadBehavior": {'behavior': 'allow', 'downloadPath': download_dir}}
        options.add_experimental_option("prefs",prefs);
        options.add_argument("--test-type");
        options.add_argument("--no-sandbox");
        options.add_argument("--incognito");
        options.add_argument("--disable-extensions");
        #options.add_argument("--start-maximized");
        return options;

    def get_options_headlesschrome(self, download_dir):
        from selenium import webdriver
        from selenium.webdriver.chrome.options import Options
        options = Options();
        prefs = {"download.default_directory": download_dir,"download.directory_upgrade": True,"download.prompt_for_download": False,"safebrowsing.enabled": False,"safebrowsing.disable_download_protection": True,"page.setDownloadBehavior": {'behavior': 'allow', 'downloadPath': download_dir}}
        options.add_experimental_option("prefs",prefs);
        options.add_argument("--test-type");
        options.add_argument("--headless");
        options.add_argument("--no-sandbox");
        options.add_argument("--disable-gpu");
        options.add_argument("--incognito");
        options.add_argument("--disable-extensions");
        #options.add_argument("window-size=1920x1080");
        return options;

    def enable_download_in_headless_chrome(self, driver, download_dir):
        driver.command_executor._commands["send_command"] = ("POST", '/session/$sessionId/chromium/send_command')
        params = {'cmd': 'Page.setDownloadBehavior', 'params': {'behavior': 'allow', 'downloadPath': download_dir}}
        command_result = driver.execute("send_command", params)
        print("response from browser:")
        for key in command_result:
            print("result:" + key + ":" + str(command_result[key]))