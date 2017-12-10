(ns line-server.routes.services
  (:require [clojure.tools.logging :as log]
            [compojure.api.sweet :refer :all]
            [line-server.domain.file :as f]
            [ring.util.http-response :refer :all]
            [schema.core :as s]))

(defapi service-routes
  {:swagger {:ui "/swagger-ui"
             :spec "/swagger.json"
             :data {:info {:version "1.0.0"
                           :title "Line Server"
                           :description "Sample Services"}}}}

  (context "/lines" []
    :tags ["line server"]
    (GET "/:l" []
      :return String
      :path-params [l :- Long]
      :summary "returns the line from the loaded file where l is the line number,"
      (f/get-line l)))

  (context "/api" []
    :tags ["sample math"]

    (GET "/plus" []
      :return       Long
      :query-params [x :- Long, {y :- Long 1}]
      :summary      "x+y with query-parameters. y defaults to 1."
      (ok (+ x y)))

    (POST "/minus" []
      :return      Long
      :body-params [x :- Long, y :- Long]
      :summary     "x-y with body-parameters."
      (ok (- x y)))

    (GET "/times/:x/:y" []
      :return      Long
      :path-params [x :- Long, y :- Long]
      :summary     "x*y with path-parameters"
      (ok (* x y)))

    (POST "/divide" []
      :return      Double
      :form-params [x :- Long, y :- Long]
      :summary     "x/y with form-parameters"
      (ok (/ x y)))

    (GET "/power" []
      :return      Long
      :header-params [x :- Long, y :- Long]
      :summary     "x^y with header-parameters"
      (ok (long (Math/pow x y))))))
