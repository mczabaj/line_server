(ns line-server.env
  (:require [clojure.tools.logging :as log]))

(def defaults
  {:init
   (fn []
     (log/info "\n-=[line_server started successfully]=-"))
   :stop
   (fn []
     (log/info "\n-=[line_server has shut down successfully]=-"))
   :middleware identity})
